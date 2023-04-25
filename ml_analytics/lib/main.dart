import 'package:flutter/material.dart';
import 'package:ml_analytics/pages/upload_file_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ML Analytics',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UploadFileScreen()
    );
  }
}
