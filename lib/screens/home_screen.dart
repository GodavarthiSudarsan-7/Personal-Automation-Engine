import 'package:flutter/material.dart';
import 'create_rule_screen.dart';
import '../engine/rule_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final rules = RuleManager.getRules();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Automation Rules"),
      ),

      body: rules.isEmpty
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

                return ListTile(
                  title: Text(rule.name),
                  subtitle: Text("Trigger: ${rule.triggerType}"),
                );
              },
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