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
        body: TabBarView(children: [
          _playersListView(),
          Scaffold(body: _listView(_playerWarView)),
          Scaffold(body: _listView(_playerMoneyView)),
          Scaffold(body: _listView(_playerTotalView)),
          Scaffold(body: _listView(_playerTotalView)),
          Scaffold(body: _listView(_playerTotalView)),
          Scaffold(body: _listView(_playerTotalView)),
          Scaffold(body: _listView(_playerTotalView)),
          Scaffold(body: _listView(_playerTotalView)),
        ]),
      ),
    );
  }

  Widget _playersListView() {
    return Scaffold(
      body: _listView(_playerView),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: _addPlayerLayout,
        child: new Icon(Icons.add),
      ),
    );
  }

// _listView display a player list with a function for all player list tile
  Widget _listView(Widget Function(int, Player) playerView) {
    return new Container(
      margin: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
      child: ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          return playerView(index, players[index]);
        },
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

  Widget _playerView(int index, Player player) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
        title: Text('${players[index].name}'),
        trailing: Wrap(
          spacing: 12,
          children: <Widget>[
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

  Widget _playerTotalView(int i, Player p) {
    return new Card(
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
              title: new Text('${p.name}'),
            ),
            flex: 3,
          ),
          Expanded(
            child: ListTile(
              title: new Text('${p.totalScore()}'),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  Widget _playerWarView(int i, Player p) {
    return new Card(
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
              title: new Text('${p.name}'),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_outlined, size: 15.0),
                onPressed: () {
                  setState(() {
                    p.warScore--;
                  });
                },
              ),
              Text(p.warScore.toString()),
              IconButton(
                icon: Icon(Icons.add_outlined, size: 15.0),
                onPressed: () {
                  setState(() {
                    p.warScore++;
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _playerMoneyView(int i, Player p) {
    return new Card(
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
              title: new Text('${p.name}'),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_outlined, size: 15.0),
                onPressed: () {
                  setState(() {
                    p.moneyScore.value--;
                  });
                },
              ),
              Text(p.moneyScore.value.toString()),
              IconButton(
                icon: Icon(Icons.add_outlined, size: 15.0),
                onPressed: () {
                  setState(() {
                    p.moneyScore.value++;
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
