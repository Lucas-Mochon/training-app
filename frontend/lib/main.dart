import 'package:flutter/material.dart';
import 'package:frontend/app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Training App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFD32F2F),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          titleTextStyle: TextStyle(color: Colors.white),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: const App(),
    );
  }
}
