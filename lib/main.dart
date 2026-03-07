import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const AutomationApp());
}

class AutomationApp extends StatelessWidget {
  const AutomationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Automation Engine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}