class ActionExecutor {

  static void executeActions(
    String ruleName,
    List<Map<String, dynamic>> actions,
  ) {

    for (var action in actions) {

      String type = action["type"];

      if (type == "notification") {

        print("Notification executed for rule: $ruleName");

      }

      else if (type == "log") {

        print("Log entry created for rule: $ruleName");

      }

      else if (type == "open_app") {

        print("Opening application for rule: $ruleName");

      }

    }

  }

}