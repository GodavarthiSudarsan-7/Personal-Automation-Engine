import 'dart:convert';
import '../models/rule.dart';
import 'rule_manager.dart';

class JsonManager {

  static String exportRules() {

    List<Rule> rules = RuleManager.getRules();

    List<Map<String, dynamic>> data =
        rules.map((rule) => rule.toJson()).toList();

    return jsonEncode(data);

  }

}