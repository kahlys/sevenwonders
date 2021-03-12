import 'dart:math';

import 'dart:ui';

class Player {
  String? name;

  int warScore = 0;
  int wonderScore = 0;
  int civilianScore = 0;
  int commerceScore = 0;
  int guildeScore = 0;

  int money = 0;

  // science
  int gears = 0;
  int compass = 0;
  int tablets = 0;
  int wilds = 0;

  Player(String name) {
    this.name = name;
  }

  int totalScore() {
    return this.warScore +
        this.wonderScore +
        this.civilianScore +
        this.commerceScore +
        this.guildeScore +
        _moneyScore(this.money) +
        _scienceScore(this.wilds, this.compass, this.gears, this.tablets);
  }

  static int _moneyScore(int m) {
    return m ~/ 3;
  }

  // _scienceScore calcultation according to wilds, compass, gears, and tablets.
  static int _scienceScore(int w, int c, int g, int t) {
    if (w <= 0) {
      return (g * g) + (c * c) + (t * t) + 7 * (min(min(c, g), t));
    }
    return max(
        max(_scienceScore(w - 1, c + 1, g, t),
            _scienceScore(w - 1, c, g + 1, t)),
        _scienceScore(w - 1, c, g, t + 1));
  }
}
