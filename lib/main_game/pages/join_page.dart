import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final/main_game/game_data.dart';
import 'package:flutter_final/main_game/player.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({Key? key}) : super(key: key);

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  late TextEditingController _controller;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  String debugText = "";
  String roomID = "";
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("加入遊戲房間"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(debugText),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "房間ID",
              ),
              controller: _controller,
            ),
            ElevatedButton(
              onPressed: () {
                dbRef.child("rooms").child(_controller.text).onValue.listen((event){
                  DataSnapshot snapshot = event.snapshot;
                  Object? returnValues = snapshot.value;
                  String result = returnValues.toString();
                  setState(() {
                    debugText = result;
                  });
                  if(returnValues != null){
                    Map<dynamic, dynamic> values = returnValues as Map<dynamic, dynamic>;
                    Navigator.pushNamed(context, "/ticTacToe", arguments: GameData(
                      roomID: _controller.text,
                      player1: values["player1"],
                      player2: Player.playerInstance.name,
                      status: "playing",
                      board: [
                        ["X", "", ""],
                        ["", "", ""],
                        ["", "", ""],
                      ],
                      player1Move: true,
                      isPlayer1: false,
                      isGameOver: false,
                      winner: "",
                    ));
                    DatabaseReference ref = dbRef;
                    ref.child("rooms").child(_controller.text).update({
                      "player2": Player.playerInstance.name,
                      "status" : "playing",
                    });
                  }
                });
              },
              child: const Text("加入遊戲"),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/home");
                },
                child: const Text("返回")),
          ],
        ),
      ),
    );
  }
}
