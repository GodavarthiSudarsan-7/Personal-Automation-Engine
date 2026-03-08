class Rule {

  String id;
  String name;
  bool enabled;

  String triggerType;
  Map<String, dynamic> triggerParams;

  List<Map<String, dynamic>> conditions;
  List<Map<String, dynamic>> actions;

  Rule({
    required this.id,
    required this.name,
    required this.enabled,
    required this.triggerType,
    required this.triggerParams,
    required this.conditions,
    required this.actions,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "enabled": enabled,
      "triggerType": triggerType,
      "triggerParams": triggerParams,
      "conditions": conditions,
      "actions": actions,
    };
  }

  factory Rule.fromJson(Map<String, dynamic> json) {

    List<Map<String, dynamic>> parsedConditions = [];
    List<Map<String, dynamic>> parsedActions = [];

    if (json["conditions"] != null) {
      for (var item in json["conditions"]) {
        parsedConditions.add(Map<String, dynamic>.from(item));
      }
    }

    if (json["actions"] != null) {
      for (var item in json["actions"]) {
        parsedActions.add(Map<String, dynamic>.from(item));
      }
    }

    return Rule(
      id: json["id"],
      name: json["name"],
      enabled: json["enabled"],
      triggerType: json["triggerType"],
      triggerParams: Map<String, dynamic>.from(json["triggerParams"] ?? {}),
      conditions: parsedConditions,
      actions: parsedActions,
    );
  }

}