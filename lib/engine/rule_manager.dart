import '../models/rule.dart';
import '../storage/rule_storage.dart';

class RuleManager {

  static List<Rule> rules = [];

  static void loadRules() {

    rules = RuleStorage.loadRules();

  }

  static void addRule(Rule rule) {

    rules.add(rule);
    RuleStorage.saveRule(rule);

  }

  static List<Rule> getRules() {

    return rules;

  }

}