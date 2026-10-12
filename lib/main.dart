import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const TreviaBagApp());
}

class TreviaBagApp extends StatelessWidget {
  const TreviaBagApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trevia Bag',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}