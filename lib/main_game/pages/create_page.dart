import 'dart:convert';
import 'dart:math';

import 'package:flutter_final/main_game/player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final/main_game/game_data.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});
  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  String roomID = "";
  String done = "No";
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  @override
  void initState() {
    super.initState();
    roomID = generateRandomString(4);
    createRoom();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // });
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("新增遊戲房間"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("房間ID: $roomID"),
            Text(done),
            ElevatedButton(
              onPressed: () {
                createRoom();
              },
              child: const Text("新增遊戲"),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/home");
                },
                child: const Text("返回")),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/test");
                },
                child: const Text("go to test")),
          ],
        ),
      ),
    );
  }

  String generateRandomString(int len) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    final Random rnd = Random.secure();
    return String.fromCharCodes(Iterable.generate(
        len, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  void createRoom() {
    Map<String, dynamic> data = {
      "roomID": roomID,
      "status": "waiting",
      "player1": Player.playerInstance.name,
      "player2": "",
      "board": [
        ["", "", ""],
        ["", "", ""],
        ["", "", ""],
      ],
      "player1Move": true,
      "isGameOver": false,
      "winner": "",
    };
    dbRef.child("rooms").child(roomID).set(data).then((value) {
      setState(() {
        done = "Yes";
      });
    });
  }

  void readData() {
    dbRef.child("rooms").child(roomID).onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      setState(() {
        done = dataSnapshot.value.toString();
      });
      // if(dataSnapshot.value == null){
      //   return;
      // }
      Map<dynamic, dynamic> values = dataSnapshot.value as Map<dynamic, dynamic>;
      // String result = values.toString();
      if(values["status"] == "playing"){
        Navigator.pushNamed(context, "/ticTacToe", arguments: GameData(
          roomID: roomID,
          player1: values["player1"],
          player2: values["player2"],
          status: "playing",
          board: [
            ["", "", ""],
            ["", "", ""],
            ["", "", ""],
          ],
          player1Move: true,
          isPlayer1: true,
          isGameOver: false,
          winner: "",
        ));
      }
    });
  }
}
