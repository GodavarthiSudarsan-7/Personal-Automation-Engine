import '../models/log_entry.dart';

class LogManager {

  static List<LogEntry> logs = [];

  static void addLog(String ruleName) {

    final log = LogEntry(
      ruleName: ruleName,
      time: _formatTime(DateTime.now()),
    );

    logs.insert(0, log);

  }

  static List<LogEntry> getLogs() {
    return logs;
  }

  static String _formatTime(DateTime time) {

    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    String second = time.second.toString().padLeft(2, '0');

    return "$hour:$minute:$second";
  }

}