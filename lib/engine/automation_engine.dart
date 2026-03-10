import '../models/rule.dart';
import 'rule_manager.dart';
import '../actions/action_executor.dart';

class AutomationEngine {

  static void evaluateTrigger(String triggerType, Map<String, dynamic> data) {

    List<Rule> rules = RuleManager.getRules();

    for (Rule rule in rules) {

      if (!rule.enabled) continue;

      if (rule.triggerType == triggerType) {

        bool conditionsPassed = evaluateConditions(rule, data);

        if (conditionsPassed) {

          ActionExecutor.executeActions(
            rule.name,
            rule.actions,
          );

        }

      }

    }

  }

  static bool evaluateConditions(Rule rule, Map<String, dynamic> data) {

    if (rule.conditions.isEmpty) {
      return true;
    }

    for (var condition in rule.conditions) {

      String type = condition["type"];
      dynamic value = condition["value"];

      if (type == "battery_less_than") {

        if (!data.containsKey("battery")) return false;

        int batteryLevel = data["battery"];

        if (batteryLevel >= value) {
          return false;
        }

      }

    }

    return true;

  }

}