import 'dart:math';

import 'package:flutter_final/main_game/player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      createRoom();
      readData();
    });
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
                print("create room");
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
      "status": "waiting",
      "player1": Player.playerInstance.name,
      "player2": "",
    };
    dbRef.child("rooms").child(roomID).set(data).then((value) {
      setState(() {
        done = "Yes";
      });
    });
  }

  void readData() {
    dbRef.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      Object? values = dataSnapshot.value;
      String result = values.toString();
      setState(() {
        done = result;
      });
    });
  }
}
