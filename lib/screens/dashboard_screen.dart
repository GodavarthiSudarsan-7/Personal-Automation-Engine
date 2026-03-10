import 'package:flutter/material.dart';
import '../engine/rule_manager.dart';
import '../engine/log_manager.dart';
import '../triggers/trigger_manager.dart';
import 'create_rule_screen.dart';
import 'home_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  Widget build(BuildContext context) {

    final rules = RuleManager.getRules();
    final logs = LogManager.getLogs();

    int totalRules = rules.length;
    int activeRules = rules.where((r) => r.enabled).length;

    return Scaffold(

      appBar: AppBar(
        title: const Text("Personal Automation Engine"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateRuleScreen(),
            ),
          );

          setState(() {});
        },
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              "Dashboard",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,

              children: [

                _card(
                  "Total Rules",
                  totalRules.toString(),
                  Icons.rule,
                  Colors.blue,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                ),

                _card(
                  "Active Rules",
                  activeRules.toString(),
                  Icons.play_arrow,
                  Colors.green,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                ),

                _card(
                  "Logs",
                  logs.length.toString(),
                  Icons.history,
                  Colors.orange,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                ),

                _card(
                  "Triggers",
                  "3",
                  Icons.flash_on,
                  Colors.purple,
                  () {
                    TriggerManager.batteryTrigger(10);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Battery trigger simulated"),
                      ),
                    );
                  },
                ),

              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Quick Action",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              icon: const Icon(Icons.bolt),
              label: const Text("Test Battery Trigger"),
              onPressed: () {

                TriggerManager.batteryTrigger(10);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Battery trigger executed"),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            const Text(
              "Recent Activity",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            logs.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No activity yet"),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {

                      final log = logs[index];

                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.flash_on),
                          title: Text(log.ruleName),
                          subtitle: Text(log.time),
                        ),
                      );

                    },
                  ),

          ],
        ),
      ),
    );
  }

  Widget _card(
    String label,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {

    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(icon, size: 30, color: color),

            const SizedBox(height: 10),

            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),

            const SizedBox(height: 4),

            Text(label),

          ],
        ),
      ),
    );
  }
}