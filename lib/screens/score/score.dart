import 'package:flutter/material.dart';

class ScoreSheetPage extends StatefulWidget {
  final String title = "Score Sheet";

  @override
  ScoreSheetPageState createState() => ScoreSheetPageState();
}

class ScoreSheetPageState extends State<ScoreSheetPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Feuille des scores"),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "JOUEURS"),
              Tab(text: "MILITAIRE"),
              Tab(text: "MONNAIE"),
              Tab(text: "MERVEILLE"),
              Tab(text: "CIVIL"),
              Tab(text: "COMMERCE"),
              Tab(text: "SCIENCE"),
              Tab(text: "GUILDE"),
              Tab(text: "TOTAL"),
            ],
          ),
        ),
      ),
    );
  }
}
