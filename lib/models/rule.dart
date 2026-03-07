class Rule {
  String id;
  String name;
  bool enabled;

  String triggerType;
  Map<String, dynamic> triggerParams;

  List conditions;
  List actions;

  Rule({
    required this.id,
    required this.name,
    required this.enabled,
    required this.triggerType,
    required this.triggerParams,
    required this.conditions,
    required this.actions,
  });
}