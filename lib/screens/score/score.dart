import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    LinkedHashMap<Widget, Widget> sections = LinkedHashMap.from({
      Tab(text: "JOUEURS"): _playersListView(),
      Tab(text: "MILITAIRE"): _listView(_playerWarView),
      Tab(text: "MONNAIE"): _listView(_playerMoneyView),
      Tab(text: "MERVEILLE"): _listView(_playerWonderView),
      Tab(text: "CIVIL"): _listView(_playerCivilianView),
      Tab(text: "COMMERCE"): _listView(_playerCommerceView),
      Tab(text: "SCIENCE"): _listView(_playerScienceView),
      Tab(text: "GUILDE"): _listView(_playerGuildeView),
      Tab(text: "TOTAL"): _listViewSorted(_playerTotalView),
    });

    return DefaultTabController(
      length: sections.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Feuille des scores"),
          actions: <Widget>[
            TextButton(
                child: Icon(Icons.refresh, color: Colors.white),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return new AlertDialog(
                        title: new Text('Nouvelle partie'),
                        content: new Text(
                            'Effacer les scores et recommencer une partie ?'),
                        actions: <Widget>[
                          new TextButton(
                              child: new Text('NON'),
                              onPressed: () => Navigator.of(context).pop()),
                          new TextButton(
                            child: Text("OUI"),
                            onPressed: () {
                              setState(() {
                                players = [];
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: sections.keys.toList(),
          ),
        ),
        body: TabBarView(
          children: sections.values.toList(),
        ),
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

  Widget _listViewSorted(Widget Function(int, Player) playerView) {
    List<Player> playersSorted = new List.from(players);
    playersSorted.sort((a, b) {
      if (a.totalScore() < b.totalScore()) {
        return 1;
      } else if ((a.totalScore() > b.totalScore())) {
        return -1;
      } else {
        return -Comparable.compare(a.money, b.money);
      }
    });
    return new Container(
      margin: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
      child: ListView.builder(
        itemCount: playersSorted.length,
        itemBuilder: (context, index) {
          return playerView(index, playersSorted[index]);
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
              Text('${p.warScore}'),
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
                    p.money--;
                  });
                },
              ),
              Text('${p.money}'),
              IconButton(
                icon: Icon(Icons.add_outlined, size: 15.0),
                onPressed: () {
                  setState(() {
                    p.money++;
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _playerWonderView(int i, Player p) {
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
                    p.wonderScore--;
                  });
                },
              ),
              Text('${p.wonderScore}'),
              IconButton(
                icon: Icon(Icons.add_outlined, size: 15.0),
                onPressed: () {
                  setState(() {
                    p.wonderScore++;
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _playerCivilianView(int i, Player p) {
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
                    p.civilianScore--;
                  });
                },
              ),
              Text('${p.civilianScore}'),
              IconButton(
                icon: Icon(Icons.add_outlined, size: 15.0),
                onPressed: () {
                  setState(() {
                    p.civilianScore++;
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _playerCommerceView(int i, Player p) {
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
                    p.commerceScore--;
                  });
                },
              ),
              Text('${p.commerceScore}'),
              IconButton(
                icon: Icon(Icons.add_outlined, size: 15.0),
                onPressed: () {
                  setState(() {
                    p.commerceScore++;
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _playerScienceView(int i, Player p) {
    return new Card(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
              title: new Text('${p.name}'),
            ),
          ),
          Expanded(
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
              title: Container(
                child: TextField(
                  cursorWidth: 0,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: TextEditingController()..text = '${p.compass}',
                  onChanged: (v) {
                    setState(() {
                      p.compass = int.tryParse(v.length > 0
                              ? v.replaceFirst("${p.compass}", "")
                              : "0") ??
                          p.compass;
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
              title: Container(
                child: TextField(
                  cursorWidth: 0,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: TextEditingController()..text = '${p.gears}',
                  onChanged: (v) {
                    setState(() {
                      p.gears = int.tryParse(v.length > 0
                              ? v.replaceFirst("${p.gears}", "")
                              : "0") ??
                          p.gears;
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
              title: Container(
                child: TextField(
                  cursorWidth: 0,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: TextEditingController()..text = '${p.tablets}',
                  onChanged: (v) {
                    setState(() {
                      p.tablets = int.tryParse(v.length > 0
                              ? v.replaceFirst("${p.tablets}", "")
                              : "0") ??
                          p.tablets;
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
              title: Container(
                child: TextField(
                  cursorWidth: 0,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: TextEditingController()..text = '${p.wilds}',
                  onChanged: (v) {
                    setState(() {
                      p.wilds = int.tryParse(v.length > 0
                              ? v.replaceFirst("${p.wilds}", "")
                              : "0") ??
                          p.wilds;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _playerGuildeView(int i, Player p) {
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
                    p.guildeScore--;
                  });
                },
              ),
              Text('${p.guildeScore}'),
              IconButton(
                icon: Icon(Icons.add_outlined, size: 15.0),
                onPressed: () {
                  setState(() {
                    p.guildeScore++;
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
