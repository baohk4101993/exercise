import 'package:flutter/material.dart';
import 'package:login_logout/core/di/di.dart';
import 'package:login_logout/screen/login_screen.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Flutter Login App",
      home: LoginScreen(),
    );
  }
}
