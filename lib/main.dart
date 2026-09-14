import 'package:flutter/material.dart';
import 'pages/halaman_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFAF3E6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F5C5B),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const HalamanMenu(),
    );
  }
}