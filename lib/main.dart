import 'package:flutter/material.dart';

void main() {
  runApp(const FamaApp());
}

class FamaApp extends StatelessWidget {
  const FamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FAMA App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('FAMA App'),
        ),
      ),
    );
  }
}