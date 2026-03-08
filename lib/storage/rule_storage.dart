import 'package:hive/hive.dart';
import '../models/rule.dart';

class RuleStorage {

  static final Box box = Hive.box('rules');

  static void saveRule(Rule rule) {
    box.put(rule.id, rule.toJson());
    print("Saved rule: ${rule.name}");
  }

  static List<Rule> loadRules() {

    List<Rule> rules = [];

    for (var item in box.values) {

      try {

        Map<String, dynamic> data =
            Map<String, dynamic>.from(item);

        rules.add(Rule.fromJson(data));

      } catch (e) {
        print("Error loading rule: $e");
      }

    }

    print("Hive rules loaded: ${rules.length}");

    return rules;

  }

  static void deleteRule(String id) {
    box.delete(id);
  }

}