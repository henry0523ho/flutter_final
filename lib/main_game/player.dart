class Player{
  static Player playerInstance=Player(name:defaultName());
  String name;
  Player({required this.name});
  static String defaultName(){
    return "Player${DateTime.now().millisecondsSinceEpoch%1000}";
  }
}