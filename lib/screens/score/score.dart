import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sevenwonders/models/player.dart';
import 'package:sevenwonders/components/selector.dart';
import 'package:sevenwonders/components/list_tile.dart';

class ScoreSheetPage extends StatefulWidget {
  final String title = "Score Sheet";

  const ScoreSheetPage({Key? key}) : super(key: key);

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
          title: const Text("Feuille des scores"),
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
      const Tab(text: "JOUEURS"): _playersListView(),
      const Tab(text: "MILITAIRE"): _listView(_playerWarView),
      const Tab(text: "MONNAIE"): _listView(_playerMoneyView),
    });
    if (exCities == true) {
      sections[const Tab(text: "DETTE")] = _listView(_playerDebtView);
    }
    sections.addAll({
      const Tab(text: "MERVEILLE"): _listView(_playerWonderView),
      const Tab(text: "CIVIL"): _listView(_playerCivilianView),
      const Tab(text: "COMMERCE"): _listView(_playerCommerceView),
      const Tab(text: "SCIENCE"): _listViewScience(_playerScienceView),
      const Tab(text: "GUILDE"): _listView(_playerGuildeView),
    });
    if (exLeaders == true) {
      sections[const Tab(text: "LEADERS")] = _listView(_playerLeadersView);
    }
    if (exCities == true) {
      sections[const Tab(text: "CITIES")] = _listView(_playerCitiesView);
    }
    if (exArmada == true) {
      sections[const Tab(text: "ARMADA")] = _listView(_playerArmadaView);
    }
    sections[const Tab(text: "TOTAL")] = _listViewSorted(_playerTotalView);
    return sections;
  }

  Drawer _drawer() {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Extensions'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: null,
            ),
            Column(
              children: <Widget>[
                CheckboxListTile(
                  title: const Text("Leaders"),
                  value: exLeaders,
                  onChanged: (val) {
                    setState(() {
                      exLeaders = val ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("Cities"),
                  value: exCities,
                  onChanged: (val) {
                    setState(() {
                      exCities = val ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("Armada"),
                  value: exArmada,
                  onChanged: (val) {
                    setState(() {
                      exArmada = val ?? false;
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
      child: const Icon(Icons.refresh, color: Colors.white),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Nouvelle partie'),
              content:
                  const Text('Effacer les scores et recommencer une partie ?'),
              actions: <Widget>[
                TextButton(
                    child: const Text('NON'),
                    onPressed: () => Navigator.of(context).pop()),
                TextButton(
                  child: const Text("OUI"),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addPlayerLayout,
        child: const Icon(Icons.add),
      ),
    );
  }

// _listView display a player list with a function for all player list tile
  Widget _listView(Widget Function(int, Player) playerView) {
    return Card(
      margin: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          color: Colors.black12,
        ),
        itemCount: players.length,
        itemBuilder: (context, index) {
          return playerView(index, players[index]);
        },
      ),
    );
  }

  // _listView display a player list with a function for all player list tile
  Widget _listViewScience(Widget Function(int, Player) playerView) {
    return Card(
      margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          color: Colors.black12,
        ),
        itemCount: players.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Row(
              children: const [
                Spacer(flex: 2),
                Expanded(child: Text("compas", textAlign: TextAlign.center)),
                Expanded(child: Text("roue", textAlign: TextAlign.center)),
                Expanded(child: Text("pierre", textAlign: TextAlign.center)),
                Expanded(child: Text("bonus", textAlign: TextAlign.center)),
              ],
            );
          }
          return playerView(index - 1, players[index - 1]);
        },
      ),
    );
  }

  Widget _listViewSorted(Widget Function(int, Player) playerView) {
    List<Player> playersSorted = List.from(players);
    playersSorted.sort((a, b) {
      var ascore = a.totalScore(exLeaders, exCities, exArmada);
      var bscore = b.totalScore(exLeaders, exLeaders, exArmada);
      if (ascore < bscore) {
        return 1;
      } else if (ascore > bscore) {
        return -1;
      } else {
        return -Comparable.compare(a.money, b.money);
      }
    });
    return Card(
      margin: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          color: Colors.black12,
        ),
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
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(16.0),
            ),
          ),
        );
      },
    );
  }

  Widget _playerView(int index, Player player) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      title: Text('${players[index].name}'),
      trailing: Wrap(
        spacing: 12,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() => players.removeAt(index));
            },
          ),
        ],
      ),
    );
  }

  Widget _playerTotalView(int i, Player p) {
    var score = p.totalScore(exLeaders, exCities, exArmada);
    return Row(
      children: [
        Expanded(
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            title: Text('${p.name}'),
          ),
          flex: 3,
        ),
        Expanded(
          child: ListTile(
            title: Text(
              '$score',
              textAlign: TextAlign.center,
            ),
          ),
          flex: 1,
        ),
      ],
    );
  }

  Widget _playerWarView(int i, Player p) {
    return ListTilePlayerWithNumberSelector(
      playerName: p.name!,
      selector: NumberSelector(
        value: p.warScore,
        min: -50,
        onChange: (v) {
          setState(() {
            p.warScore = v!;
          });
        },
      ),
    );
  }

  Widget _playerMoneyView(int i, Player p) {
    return ListTilePlayerWithNumberSelector(
      playerName: p.name!,
      selector: NumberSelector(
        value: p.money,
        onChange: (v) {
          setState(() {
            p.money = v!;
          });
        },
      ),
    );
  }

  Widget _playerWonderView(int i, Player p) {
    return ListTilePlayerWithNumberSelector(
      playerName: p.name!,
      selector: NumberSelector(
        value: p.wonderScore,
        onChange: (v) {
          setState(() {
            p.wonderScore = v!;
          });
        },
      ),
    );
  }

  Widget _playerCivilianView(int i, Player p) {
    return ListTilePlayerWithNumberSelector(
      playerName: p.name!,
      selector: NumberSelector(
        value: p.civilianScore,
        onChange: (v) {
          setState(() {
            p.civilianScore = v!;
          });
        },
      ),
    );
  }

  Widget _playerCommerceView(int i, Player p) {
    return ListTilePlayerWithNumberSelector(
      playerName: p.name!,
      selector: NumberSelector(
        value: p.commerceScore,
        onChange: (v) {
          setState(() {
            p.commerceScore = v!;
          });
        },
      ),
    );
  }

  Widget _playerScienceView(int i, Player p) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            title: Text('${p.name}'),
          ),
        ),
        Expanded(
          child: ListTile(
            title: TextField(
              cursorWidth: 0,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: TextEditingController()..text = '${p.compass}',
              onChanged: (v) {
                setState(() {
                  p.compass = int.tryParse(v.isNotEmpty
                          ? v.replaceFirst("${p.compass}", "")
                          : "0") ??
                      p.compass;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: TextField(
              cursorWidth: 0,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: TextEditingController()..text = '${p.gears}',
              onChanged: (v) {
                setState(() {
                  p.gears = int.tryParse(v.isNotEmpty
                          ? v.replaceFirst("${p.gears}", "")
                          : "0") ??
                      p.gears;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: TextField(
              cursorWidth: 0,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: TextEditingController()..text = '${p.tablets}',
              onChanged: (v) {
                setState(() {
                  p.tablets = int.tryParse(v.isNotEmpty
                          ? v.replaceFirst("${p.tablets}", "")
                          : "0") ??
                      p.tablets;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: TextField(
              cursorWidth: 0,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: TextEditingController()..text = '${p.wilds}',
              onChanged: (v) {
                setState(() {
                  p.wilds = int.tryParse(v.isNotEmpty
                          ? v.replaceFirst("${p.wilds}", "")
                          : "0") ??
                      p.wilds;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _playerGuildeView(int i, Player p) {
    int max = 999;
    if (exArmada) {
      max = 10;
      p.guildeScore = min(p.guildeScore, 10);
    }
    return ListTilePlayerWithNumberSelector(
      playerName: p.name!,
      selector: NumberSelector(
        value: p.guildeScore,
        max: max,
        onChange: (v) {
          setState(() {
            p.guildeScore = v!;
          });
        },
      ),
    );
  }

  Widget _playerLeadersView(int i, Player p) {
    return ListTilePlayerWithNumberSelector(
      playerName: p.name!,
      selector: NumberSelector(
        value: p.leaders,
        onChange: (v) {
          setState(() {
            p.leaders = v!;
          });
        },
      ),
    );
  }

  Widget _playerCitiesView(int i, Player p) {
    return ListTilePlayerWithNumberSelector(
      playerName: p.name!,
      selector: NumberSelector(
        value: p.cities,
        onChange: (v) {
          setState(() {
            p.cities = v!;
          });
        },
      ),
    );
  }

  Widget _playerDebtView(int i, Player p) {
    if (p.debt > 0) p.debt = 0;
    return ListTilePlayerWithNumberSelector(
      playerName: p.name!,
      selector: NumberSelector(
        value: p.debt,
        max: 0,
        min: -100,
        onChange: (v) {
          setState(() {
            p.debt = v!;
          });
        },
      ),
    );
  }

  Widget _playerArmadaView(int i, Player p) {
    return ListTilePlayerWithNumberSelector(
      playerName: p.name!,
      selector: NumberSelector(
        value: p.armada,
        onChange: (v) {
          setState(() {
            p.armada = v!;
          });
        },
      ),
    );
  }
}
