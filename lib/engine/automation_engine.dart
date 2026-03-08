import '../models/rule.dart';
import 'rule_manager.dart';

class AutomationEngine {

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

  static void executeActions(Rule rule) {

    for (var action in rule.actions) {

      String type = action["type"];

      if (type == "notification") {

        print("Notification executed for rule: ${rule.name}");

      }

    }

  }

}