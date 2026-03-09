import 'package:flutter/material.dart';
import '../models/rule.dart';
import '../engine/rule_manager.dart';

class EditRuleScreen extends StatefulWidget {

  final Rule rule;

  const EditRuleScreen({super.key, required this.rule});

  @override
  State<EditRuleScreen> createState() => _EditRuleScreenState();
}

class _EditRuleScreenState extends State<EditRuleScreen> {

  late TextEditingController ruleNameController;
  late String selectedTrigger;

  List<String> triggers = [
    "Time",
    "Battery",
    "WiFi"
  ];

  @override
  void initState() {
    super.initState();

    ruleNameController =
        TextEditingController(text: widget.rule.name);

    selectedTrigger = widget.rule.triggerType;
  }

  void updateRule() {

    widget.rule.name = ruleNameController.text;
    widget.rule.triggerType = selectedTrigger;

    RuleManager.updateRule(widget.rule);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Rule"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller: ruleNameController,
              decoration: const InputDecoration(
                labelText: "Rule Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField(
              value: selectedTrigger,
              items: triggers.map((trigger) {
                return DropdownMenuItem(
                  value: trigger,
                  child: Text(trigger),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTrigger = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: "Select Trigger",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: updateRule,
              child: const Text("Update Rule"),
            )

          ],
        ),
      ),
    );
  }
}