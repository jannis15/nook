import 'package:flutter/material.dart';

void main() {
  runApp(const NookApp());
}

class NookApp extends StatelessWidget {
  const NookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF8F7357),
      ),
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nook'),
              SizedBox(height: 8),
              Text('Personal media library setup'),
            ],
          ),
        ),
      ),
    );
  }
}
