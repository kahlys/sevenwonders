class Player {
  String? name;
  int warScore = 0;
  ScoreMoney moneyScore = ScoreMoney();

  Player(String name) {
    this.name = name;
  }

  int totalScore() {
    return this.warScore + this.moneyScore.score();
  }
}

class ScoreMoney {
  int value = 0;

  int score() {
    return this.value ~/ 3;
  }
}
