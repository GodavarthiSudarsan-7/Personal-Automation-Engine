import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/dashboard_screen.dart';
import 'engine/rule_manager.dart';
import 'services/notification_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('rules');

  RuleManager.loadRules();

  await NotificationService.initialize();

  runApp(const AutomationApp());

}

class AutomationApp extends StatelessWidget {
  const AutomationApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: "Personal Automation Engine",

      theme: ThemeData.dark().copyWith(

        scaffoldBackgroundColor: const Color(0xFF0F172A),

        primaryColor: Colors.blueAccent,

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E293B),
          elevation: 0,
          centerTitle: true,
        ),

        cardTheme: const CardThemeData(
          color: Color(0xFF1E293B),
          elevation: 4,
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blueAccent,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
          ),
        ),

      ),

      home: const DashboardScreen(),

    );

  }
}