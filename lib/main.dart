import 'package:flutter/material.dart';

import 'screens/score/score.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // tap outside of textfields to hide the soft keyboard
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: MaterialApp(
        title: 'Seven Wonders Score Sheet',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ScoreSheetPage(),
      ),
    );
  }
}
