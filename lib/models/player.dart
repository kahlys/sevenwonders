class Player {
  String? name;
  int score = 0;

  Player(String name) {
    this.name = name;
  }

  int totalScore() {
    return this.score;
  }
}