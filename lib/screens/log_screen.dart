import 'package:flutter/material.dart';
import '../engine/log_manager.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final logs = LogManager.getLogs();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Execution Logs"),
      ),
      body: logs.isEmpty
          ? const Center(
              child: Text("No logs yet"),
            )
          : ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {

                final log = logs[index];

                return ListTile(
                  title: Text(log.ruleName),
                  subtitle: Text(log.time),
                );

              },
            ),
    );
  }
}