import 'package:flutter/material.dart';
import 'package:events/screens/admin/admin_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AdminScreen(), // Use the correct class name
    );
  }
}
