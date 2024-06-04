class GameData {
  // static GameData
  String roomID = "";
  String player1 = "";
  String player2 = "";
  String status = "";
  late List<List<String>> board;
  bool player1Move = true;
  bool isPlayer1 = true;
  bool isGameOver = false;
  String winner = "";
  GameData({
    required this.roomID,
    required this.player1,
    required this.player2,
    required this.status,
    required this.board,
    required this.player1Move,
    required this.isPlayer1,
    required this.isGameOver,
    required this.winner,
  });
  GameData.fromJson(Map json) {
    roomID = json["roomID"];
    player1 = json["player1"];
    player2 = json["player2"];
    status = json["status"];
    board = List<List<String>>.from(json["board"].map((x) => List<String>.from(x.map((x) => x))));
    isPlayer1 = json["isPlayer1"];
    isGameOver = json["isGameOver"];
    winner = json["winner"];
  }
}