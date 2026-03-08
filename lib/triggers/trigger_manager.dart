import '../engine/automation_engine.dart';

class TriggerManager {

  static void timeTrigger() {

    AutomationEngine.evaluateTrigger(
      "Time",
      {
        "hour": DateTime.now().hour,
        "minute": DateTime.now().minute
      },
    );

  }

  static void batteryTrigger(int batteryLevel) {

    AutomationEngine.evaluateTrigger(
      "Battery",
      {
        "battery": batteryLevel
      },
    );

  }

  static void wifiTrigger(bool connected) {

    AutomationEngine.evaluateTrigger(
      "WiFi",
      {
        "connected": connected
      },
    );

  }

}