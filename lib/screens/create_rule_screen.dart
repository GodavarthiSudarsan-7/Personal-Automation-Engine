import 'package:flutter/material.dart';
import '../models/rule.dart';
import '../engine/rule_manager.dart';
import 'dart:math';

class CreateRuleScreen extends StatefulWidget {
  const CreateRuleScreen({super.key});

  @override
  State<CreateRuleScreen> createState() => _CreateRuleScreenState();
}

class _CreateRuleScreenState extends State<CreateRuleScreen> {

  final TextEditingController ruleNameController = TextEditingController();

  String selectedTrigger = "Time";

  List<String> triggers = [
    "Time",
    "Battery",
    "WiFi"
  ];

  void saveRule() {

    String ruleName = ruleNameController.text;

    if (ruleName.isEmpty) return;

    Rule rule = Rule(
      id: Random().nextInt(100000).toString(),
      name: ruleName,
      enabled: true,
      triggerType: selectedTrigger,
      triggerParams: {},
      conditions: [
        {
          "type": "battery_less_than",
          "value": 20
        }
      ],
      actions: [
        {
          "type": "notification"
        }
      ],
    );

    RuleManager.addRule(rule);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Rule"),
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

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveRule,
                child: const Text("Save Rule"),
              ),
            )

          ],
        ),
      ),
    );
  }
}