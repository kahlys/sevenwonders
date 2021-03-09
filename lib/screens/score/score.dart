import 'package:flutter/material.dart';

import 'package:sevenwonders/models/player.dart';

class ScoreSheetPage extends StatefulWidget {
  final String title = "Score Sheet";

  @override
  ScoreSheetPageState createState() => ScoreSheetPageState();
}

class ScoreSheetPageState extends State<ScoreSheetPage> {
  List<Player> players = [];

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
        body: _playersListView(),
      ),
    );
  }

  Widget _playersListView() {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
        child: ListView.builder(
          itemCount: players.length,
          itemBuilder: (context, index) {
            return _playerItemView(index);
          },
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: _addPlayerLayout,
        child: new Icon(Icons.add),
      ),
    );
  }

  Widget _playerItemView(int index) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
        title: Text('${players[index].name}'),
        trailing: Wrap(
          spacing: 12,
          children: <Widget>[
            // wonders name
            IconButton(
              icon: new Icon(Icons.close),
              onPressed: () {
                setState(() => players.removeAt(index));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addPlayerLayout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: TextField(
            autofocus: true,
            onSubmitted: (val) {
              setState(() {
                players.add(Player(val));
              });
              Navigator.pop(context);
            },
            decoration: new InputDecoration(
              contentPadding: const EdgeInsets.all(16.0),
            ),
          ),
        );
      },
    );
  }
}
