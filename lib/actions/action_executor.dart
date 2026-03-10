import '../engine/log_manager.dart';
import '../services/notification_service.dart';

class ActionExecutor {

  static void executeActions(
    String ruleName,
    List<Map<String, dynamic>> actions,
  ) {

    for (var action in actions) {

      String type = action["type"];

      if (type == "notification") {

        NotificationService.showNotification(
          "Automation Triggered",
          "Rule \"$ruleName\" executed",
        );

      }

      else if (type == "log") {

        LogManager.addLog(ruleName);

      }

      else if (type == "open_app") {

        print("Opening application for rule: $ruleName");

      }

    }

  }

}