import '../models/rule.dart';

class RuleManager {

  static List<Rule> rules = [];

  static void addRule(Rule rule) {
    rules.add(rule);
  }

  static List<Rule> getRules() {
    return rules;
  }

}