import 'package:flutter/material.dart';

import 'screens/score/score.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seven Wonders Score Sheet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScoreSheetPage(),
    );
  }
}
