class ActionExecutor {

  static void executeActions(String ruleName, List actions) {

    for (var action in actions) {

      String type = action["type"];

      if (type == "notification") {

        print("🔔 Notification triggered from rule: $ruleName");

      }

      else if (type == "log") {

        print("📄 Log action from rule: $ruleName");

      }

      else if (type == "toggle") {

        print("⚙ Toggle action executed for rule: $ruleName");

      }

    }

  }

}