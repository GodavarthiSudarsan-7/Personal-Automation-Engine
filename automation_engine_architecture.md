# Personal Automation Engine - System Architecture

## 1. System Architecture overview
The application fundamentally requires a robust, scalable architecture separated into clean layers to facilitate easy addition of new triggers, conditions, and actions over time. 

We apply **Clean Architecture** patterns, divided into four main layers:
- **Presentation Layer**: Flutter widgets and state management (e.g., Riverpod or BLoC). Responsible for managing rules (CRUD on rules), viewing logs, and configuring settings.
- **Domain Layer**: Contains the core business logic, including `Rule`, `Trigger`, `Condition`, and `Action` entities, alongside abstractions for data repositories.
- **Data Layer**: Concrete implementations of repositories. Uses `Hive` or `SQLite` for persisting rules offline, guaranteeing no network is needed for evaluation.
- **Engine Layer (Background Core)**: The core subsystem that manages subscriptions to data streams (triggers), executes conditional logic dynamically, and dispatches actions. This layer must run robustly within a Flutter background service (`flutter_background_service`) so rules can trigger independently of the UI.

## 2. Recommended Folder Structure
```text
lib/
├── core/
│   ├── background/             # flutter_background_service initialization
│   ├── di/                     # Dependency Injection mapping (GetIt)
│   ├── error/                  # Custom exceptions and failures
│   └── utils/                  # Logger, extensions, constants
├── domain/
│   ├── entities/               # Rule, Trigger event payloads
│   └── repositories/           # Abstract interfaces for RuleRepository, LogRepository
├── data/
│   ├── models/                 # Hive/SQLite DTOs (e.g., RuleModel)
│   ├── repositories/           # Concrete Repository implementations
│   └── local/                  # Hive boxes or SQLite DB setup
├── engine/
│   ├── rule_engine.dart        # Core engine orchestrating evaluation
│   ├── core/                   # Engine base classes (Action, Condition, Trigger)
│   ├── triggers/               # e.g., time_trigger.dart, battery_trigger.dart
│   ├── conditions/             # e.g., wifi_condition.dart, time_range_condition.dart
│   └── actions/                # e.g., notification_action.dart, volume_action.dart
└── presentation/
    ├── app.dart                # MaterialApp
    ├── pages/                  # DashboardPage, RuleEditorPage
    ├── widgets/                # Reusable UI (RuleCard, TriggerSelector)
    └── state/                  # BLoC/Providers managing UI state
```

## 3. Core Classes and Interfaces

The architecture prioritizes polymorphism. Everything is built around base classes, enforcing a modular contract.

### Base Abstractions
```dart
abstract class Trigger {
  final String id;
  const Trigger(this.id);
  
  /// Returns a stream that emits events when the trigger occurs.
  Stream<TriggerEvent> get stream;
}

abstract class Condition {
  final String id;
  const Condition(this.id);

  /// Dynamically evaluate the condition state at execution time.
  Future<bool> evaluate();
}

abstract class Action {
  final String id;
  const Action(this.id);

  /// Execute the side-effect.
  Future<void> execute();
}

/// A wrapper indicating a trigger has fired.
class TriggerEvent {
  final String sourceId;
  final dynamic payload;
  final DateTime timestamp;

  TriggerEvent({required this.sourceId, this.payload, required this.timestamp});
}
```

### Core Entity
```dart
class Rule {
  final String id;
  final String name;
  final bool isEnabled;
  final int priority; // Optional enhancement
  
  final Trigger trigger;
  final List<Condition> conditions;
  final List<Action> actions;

  Rule({
    required this.id,
    required this.name,
    this.isEnabled = true,
    this.priority = 0,
    required this.trigger,
    this.conditions = const [],
    required this.actions,
  });
}
```

## 4. Example Implementations of Engine Components

To show how new plugins (actions, triggers) can be added:

```dart
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// --- Trigger Implementation ---
class BatteryTrigger extends Trigger {
  final int threshold;
  
  BatteryTrigger(String id, {required this.threshold}) : super(id);

  @override
  Stream<TriggerEvent> get stream async* {
    // Wraps the third-party battery package stream into our system's event
    await for (final state in Battery().onBatteryStateChanged) {
       final level = await Battery().batteryLevel;
       if (level <= threshold) {
         yield TriggerEvent(
            sourceId: id, 
            payload: {'level': level, 'state': state}, 
            timestamp: DateTime.now(),
         );
       }
    }
  }
}

// --- Condition Implementation ---
class WifiCondition extends Condition {
  WifiCondition(String id) : super(id);

  @override
  Future<bool> evaluate() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.wifi;
  }
}

// --- Action Implementation ---
class NotificationAction extends Action {
  final String title;
  final String message;

  NotificationAction(String id, {required this.title, required this.message}) : super(id);

  @override
  Future<void> execute() async {
    // Utilize flutter_local_notifications
    await NotificationService.show(title, message);
  }
}
```

## 5. The Rule Engine Pipeline

The `RuleEngine` is designed to be highly efficient, mapping triggers to active subscriptions and reacting to events as they drop.

```dart
import 'dart:async';

class RuleEngine {
  final Map<String, StreamSubscription> _activeTriggers = {};
  
  // Optional enhancement: Broadcast metrics/logs.
  final StreamController<RuleExecutionLog> _logController = StreamController.broadcast();

  // Load and register all enabled rules (usually called on boot inside the background service)
  Future<void> initialize(List<Rule> activeRules) async {
    for (final rule in activeRules) {
      if (rule.isEnabled) {
        _registerRule(rule);
      }
    }
  }

  void _registerRule(Rule rule) {
    if (_activeTriggers.containsKey(rule.id)) return;

    // Listen to the trigger's native stream
    final subscription = rule.trigger.stream.listen((event) async {
      await _processRuleExecution(rule, event);
    });

    _activeTriggers[rule.id] = subscription;
  }

  Future<void> _processRuleExecution(Rule rule, TriggerEvent event) async {
    _logController.add(RuleExecutionLog(rule.id, "Triggered by ${event.sourceId}"));

    // 1. Evaluate Conditions (Fail-fast strategy)
    for (final condition in rule.conditions) {
      final isMet = await condition.evaluate();
      if (!isMet) {
         _logController.add(RuleExecutionLog(rule.id, "Condition prevented execution: ${condition.id}"));
         return; // Halt execution if a condition is not satisfied
      }
    }

    // 2. Execute Actions (Modular dispatch)
    for (final action in rule.actions) {
      try {
        await action.execute();
        _logController.add(RuleExecutionLog(rule.id, "Action executed successfully: ${action.id}"));
      } catch (e) {
        _logController.add(RuleExecutionLog(rule.id, "Action failed: ${action.id} - Error: $e"));
      }
    }
  }

  // Called when user disables a rule or deletes it
  void unregisterRule(String ruleId) {
    _activeTriggers[ruleId]?.cancel();
    _activeTriggers.remove(ruleId);
  }

  // Graceful shutdown
  void dispose() {
    for (final sub in _activeTriggers.values) {
      sub.cancel();
    }
    _activeTriggers.clear();
    _logController.close();
  }
}

class RuleExecutionLog {
  final String ruleId;
  final String message;
  final DateTime timestamp;

  RuleExecutionLog(this.ruleId, this.message) : timestamp = DateTime.now();
}
```

## 6. Execution Flow & Background Handling

1. **Foreground**: The user creates a rule, adding a `TimeTrigger`, a `WifiCondition`, and a `NotificationAction`. The UI maps these to JSON and saves them via `Hive`.
2. **Notification to Background**: The UI sends a message to the isolate running `flutter_background_service`.
3. **Engine Refresh**: The `RuleEngine` running in the background isolate unregisters the old version of the rule and registers the new stream for `TimeTrigger`.
4. **Action**: Every tick, `TimeTrigger` evaluates the time. When matched, it puts an event on the stream.
5. **Processing**: `RuleEngine` intercepts the event, awaits `WifiCondition.evaluate()`. If true, loops through Actions and fires `NotificationAction.execute()`.
