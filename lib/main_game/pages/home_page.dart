import 'package:flutter/material.dart';
import 'package:flutter_final/main_game/player.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Player player = Player.playerInstance;
  @override
  void initState() {
    super.initState();
    setState(() {
      player = Player.playerInstance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("首頁"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("歡迎 ${player.name}"),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/create");
              },
              child: const Text("新增遊戲房間"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/join");
              },
              child: const Text("加入遊戲房間"),
            ),
          ],
        ),
      ),
    );
  }
}