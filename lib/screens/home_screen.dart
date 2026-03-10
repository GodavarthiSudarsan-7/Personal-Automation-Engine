import 'package:flutter/material.dart';
import 'create_rule_screen.dart';
import 'edit_rule_screen.dart';
import '../engine/rule_manager.dart';
import '../triggers/trigger_manager.dart';
import '../engine/json_manager.dart';
import 'log_screen.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {

    final rules = RuleManager.getRules();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Automation Rules"),
        actions: [

          IconButton(
            icon: const Icon(Icons.dashboard),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DashboardScreen(),
                ),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {

              String json = JsonManager.exportRules();

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Exported JSON"),
                  content: SingleChildScrollView(
                    child: Text(json),
                  ),
                ),
              );

            },
          ),

          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LogScreen(),
                ),
              );
            },
          )

        ],
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

                          subtitle: Text(
                            "Trigger: ${rule.triggerType}",
                          ),

                          onTap: () async {

                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditRuleScreen(rule: rule),
                              ),
                            );

                            setState(() {});

                          },

                          leading: Switch(
                            value: rule.enabled,
                            onChanged: (value) {

                              setState(() {
                                RuleManager.toggleRule(rule.id);
                              });

                            },
                          ),

                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {

                              setState(() {
                                RuleManager.deleteRule(rule.id);
                              });

                            },
                          ),

                        ),
                      );

                    },
                  ),
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {

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

          setState(() {});

        },
        child: const Icon(Icons.add),
      ),
    );
  }
}