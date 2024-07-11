import 'package:flutter/material.dart';
import 'roadmap_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Manager Roadmap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RoadmapScreen(),
    );
  }
}
