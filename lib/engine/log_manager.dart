import '../models/log_entry.dart';

class LogManager {

  static List<LogEntry> logs = [];

  static void addLog(String ruleName) {

    String time = DateTime.now().toString();

    logs.add(
      LogEntry(
        ruleName: ruleName,
        time: time,
      ),
    );

  }

  static List<LogEntry> getLogs() {
    return logs;
  }

}