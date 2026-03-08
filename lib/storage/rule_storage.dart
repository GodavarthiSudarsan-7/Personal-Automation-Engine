import 'package:hive/hive.dart';
import '../models/rule.dart';

class RuleStorage {

  static final Box box = Hive.box('rules');

  static void saveRule(Rule rule) {

    box.put(rule.id, rule.toJson());

  }

  static List<Rule> loadRules() {

    List<Rule> rules = [];

    for (var item in box.values) {
      rules.add(Rule.fromJson(Map<String, dynamic>.from(item)));
    }

    return rules;

  }

  static void deleteRule(String id) {

    box.delete(id);

  }

}