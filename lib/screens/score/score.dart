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

  bool exLeaders = false;
  bool exCities = false;
  bool exArmada = false;

  @override
  Widget build(BuildContext context) {
    var sections = _tabsSections();

    return DefaultTabController(
      length: sections.length,
      child: Scaffold(
        drawer: _drawer(),
        appBar: AppBar(
          title: Text("Feuille des scores"),
          actions: <Widget>[
            _actionNewGame(context),
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

  LinkedHashMap<Widget, Widget> _tabsSections() {
    LinkedHashMap<Widget, Widget> sections = LinkedHashMap();
    sections.addAll({
      Tab(text: "JOUEURS"): _playersListView(),
      Tab(text: "MILITAIRE"): _listView(_playerWarView),
      Tab(text: "MONNAIE"): _listView(_playerMoneyView),
    });
    if (this.exCities == true) {
      sections[Tab(text: "DETTE")] = _listView(_playerDebtView);
    }
    sections.addAll({
      Tab(text: "MERVEILLE"): _listView(_playerWonderView),
      Tab(text: "CIVIL"): _listView(_playerCivilianView),
      Tab(text: "COMMERCE"): _listView(_playerCommerceView),
      Tab(text: "SCIENCE"): _listViewScience(_playerScienceView),
      Tab(text: "GUILDE"): _listView(_playerGuildeView),
    });
    if (this.exLeaders == true) {
      sections[Tab(text: "LEADERS")] = _listView(_playerLeadersView);
    }
    if (this.exCities == true) {
      sections[Tab(text: "CITIES")] = _listView(_playerCitiesView);
    }
    if (this.exArmada == true) {
      sections[Tab(text: "ARMADA")] = _listView(_playerArmadaView);
    }
    sections[Tab(text: "TOTAL")] = _listViewSorted(_playerTotalView);
    return sections;
  }

  Drawer _drawer() {
    return Drawer(
      child: new Container(
        padding: EdgeInsets.zero,
        child: new Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Extensions'.toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: null,
            ),
            Column(
              children: <Widget>[
                CheckboxListTile(
                  title: Text("Leaders"),
                  value: this.exLeaders,
                  // controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (val) {
                    setState(() {
                      exLeaders = val ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Cities"),
                  value: this.exCities,
                  // controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (val) {
                    setState(() {
                      exCities = val ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Armada"),
                  value: this.exArmada,
                  // controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (val) {
                    setState(() {
                      this.exArmada = val ?? false;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextButton _actionNewGame(BuildContext context) {
    return TextButton(
      child: Icon(Icons.refresh, color: Colors.white),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: new Text('Nouvelle partie'),
              content:
                  new Text('Effacer les scores et recommencer une partie ?'),
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
      },
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

  // _listView display a player list with a function for all player list tile
  Widget _listViewScience(Widget Function(int, Player) playerView) {
    return new Container(
      margin: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
      child: ListView.builder(
        itemCount: players.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Spacer(flex: 2),
                  Expanded(
                      flex: 1,
                      child: Text("compas", textAlign: TextAlign.center)),
                  Expanded(
                      flex: 1,
                      child: Text("roue", textAlign: TextAlign.center)),
                  Expanded(
                      flex: 1,
                      child: Text("pierre", textAlign: TextAlign.center)),
                  Expanded(
                      flex: 1,
                      child: Text("bonus", textAlign: TextAlign.center)),
                ],
              ),
            );
          }
          return playerView(index - 1, players[index - 1]);
        },
      ),
    );
  }

  Widget _listViewSorted(Widget Function(int, Player) playerView) {
    List<Player> playersSorted = new List.from(players);
    playersSorted.sort((a, b) {
      var ascore = a.totalScore(this.exLeaders, this.exCities, this.exArmada);
      var bscore = b.totalScore(this.exLeaders, this.exLeaders, this.exArmada);
      if (ascore < bscore) {
        return 1;
      } else if (ascore > bscore) {
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
    var score = p.totalScore(this.exLeaders, this.exCities, this.exArmada);
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
              title: new Text('$score'),
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
                    if (this.exArmada && p.guildeScore > 10) {
                      p.guildeScore = 10;
                    }
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _playerLeadersView(int i, Player p) {
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
                    p.leaders--;
                  });
                },
              ),
              Text('${p.leaders}'),
              IconButton(
                icon: Icon(Icons.add_outlined, size: 15.0),
                onPressed: () {
                  setState(() {
                    p.leaders++;
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _playerCitiesView(int i, Player p) {
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
                    p.cities--;
                  });
                },
              ),
              Text('${p.cities}'),
              IconButton(
                icon: Icon(Icons.add_outlined, size: 15.0),
                onPressed: () {
                  setState(() {
                    p.cities++;
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _playerDebtView(int i, Player p) {
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
                    p.debt--;
                  });
                },
              ),
              Text('${p.debt}'),
              IconButton(
                icon: Icon(Icons.add_outlined, size: 15.0),
                onPressed: () {
                  setState(() {
                    p.debt++;
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _playerArmadaView(int i, Player p) {
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
                    p.armada--;
                  });
                },
              ),
              Text('${p.armada}'),
              IconButton(
                icon: Icon(Icons.add_outlined, size: 15.0),
                onPressed: () {
                  setState(() {
                    p.armada++;
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
