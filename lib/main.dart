import 'package:flutter/material.dart';

import 'screens/score/score.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // tap outside of textfields to hide the soft keyboard
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MaterialApp(
        title: 'Seven Wonders Score Sheet',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const ScoreSheetPage(),
      ),
    );
  }
}
