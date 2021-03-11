class Player {
  String? name;
  int warScore = 0;

  Player(String name) {
    this.name = name;
  }

  int totalScore() {
    return this.warScore;
  }
}