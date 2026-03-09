import '../models/rule.dart';
import '../storage/rule_storage.dart';

class RuleManager {

  static List<Rule> rules = [];

  static void loadRules() {
    rules = RuleStorage.loadRules();
    print("Loaded rules: ${rules.length}");
  }

  static void addRule(Rule rule) {
    rules.add(rule);
    RuleStorage.saveRule(rule);
  }

  static List<Rule> getRules() {
    return rules;
  }

  static void deleteRule(String id) {
    rules.removeWhere((rule) => rule.id == id);
    RuleStorage.deleteRule(id);
  }

  static void toggleRule(String id) {
    for (var rule in rules) {
      if (rule.id == id) {
        rule.enabled = !rule.enabled;
        RuleStorage.saveRule(rule);
        break;
      }
    }
  }

  static void updateRule(Rule updatedRule) {

    for (int i = 0; i < rules.length; i++) {

      if (rules[i].id == updatedRule.id) {
        rules[i] = updatedRule;
        RuleStorage.saveRule(updatedRule);
        break;
      }

    }

  }

}