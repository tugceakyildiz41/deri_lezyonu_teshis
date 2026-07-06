import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const DeriLezyonuApp());
}

class DeriLezyonuApp extends StatelessWidget {
  const DeriLezyonuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deri Lezyonu Analizi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}