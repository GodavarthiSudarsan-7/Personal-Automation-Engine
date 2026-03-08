import '../models/rule.dart';
import 'rule_manager.dart';
import '../actions/action_executor.dart';

class AutomationEngine {

  // Called when a trigger happens
  static void evaluateTrigger(String triggerType, Map<String, dynamic> data) {

    List<Rule> rules = RuleManager.getRules();

    for (Rule rule in rules) {

      if (!rule.enabled) continue;

      if (rule.triggerType == triggerType) {

        bool conditionsPassed = evaluateConditions(rule, data);

        if (conditionsPassed) {
          executeActions(rule);
        }

      }

    }

  }

  // Check rule conditions
  static bool evaluateConditions(Rule rule, Map<String, dynamic> data) {

    for (var condition in rule.conditions) {

      String type = condition["type"];
      dynamic value = condition["value"];

      if (type == "battery") {

        if (data["battery"] >= value) {
          return false;
        }

      }

    }

    return true;
  }

  // Execute rule actions
  static void executeActions(Rule rule) {

    ActionExecutor.executeActions(
      rule.name,
      rule.actions,
    );

  }

}