import 'package:flutter/material.dart';
import 'create_rule_screen.dart';
import '../engine/rule_manager.dart';
import '../triggers/trigger_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final rules = RuleManager.getRules();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Automation Rules"),
      ),

      body: Column(
        children: [

          Expanded(
            child: rules.isEmpty
                ? const Center(
                    child: Text(
                      "No rules yet",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: rules.length,
                    itemBuilder: (context, index) {

                      final rule = rules[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ListTile(
                          title: Text(rule.name),
                          subtitle: Text("Trigger: ${rule.triggerType}"),
                          trailing: Icon(
                            rule.enabled
                                ? Icons.toggle_on
                                : Icons.toggle_off,
                            color: rule.enabled
                                ? Colors.green
                                : Colors.grey,
                            size: 32,
                          ),
                        ),
                      );

                    },
                  ),
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {

              // Test trigger
              TriggerManager.batteryTrigger(10);

            },
            child: const Text("Test Battery Trigger"),
          ),

          const SizedBox(height: 10)

        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateRuleScreen(),
            ),
          );

          (context as Element).markNeedsBuild();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}