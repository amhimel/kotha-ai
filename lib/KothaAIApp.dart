import 'package:flutter/material.dart';
import 'CustomTheme.dart';
import 'ui/screens/home_screen.dart';

class KothaAIApp extends StatelessWidget {
  const KothaAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KothaAI',
      theme: kothaAITheme,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}