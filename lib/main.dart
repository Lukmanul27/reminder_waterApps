import 'package:flutter/material.dart';
import 'package:reminderwater_apss/pages/homepage.dart';
import 'package:reminderwater_apss/pages/reminder_page.dart';
import 'package:reminderwater_apss/pages/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Reminder',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => ReminderPage(),
        '/home': (context) => HomePage(),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}
