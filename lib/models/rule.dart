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

  // Convert Rule → JSON
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

  // Convert JSON → Rule
  factory Rule.fromJson(Map<String, dynamic> json) {
    return Rule(
      id: json["id"],
      name: json["name"],
      enabled: json["enabled"],
      triggerType: json["triggerType"],
      triggerParams: Map<String, dynamic>.from(json["triggerParams"]),
      conditions: List<Map<String, dynamic>>.from(json["conditions"]),
      actions: List<Map<String, dynamic>>.from(json["actions"]),
    );
  }

}