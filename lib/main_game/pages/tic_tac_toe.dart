import 'dart:math';

import 'package:flutter_final/main_game/game_data.dart';
import 'package:flutter_final/main_game/player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class TicTacToe extends StatefulWidget {
  static const String routeName = '/ticTacToe';
  String roomID = "";
  String player1 = "";
  String player2 = "";
  String status = "";
  late List<List<String>> board;
  bool player1Move = true;
  bool isPlayer1 = true;
  bool isGameOver = false;
  String winner = "";
  @override
  State<TicTacToe> createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  List<List<String>> board = [
    ["", "", ""],
    ["", "", ""],
    ["", "", ""],
  ];
  bool player1Move = true;
  bool isPlayer1 = true;
  bool isGameOver = false;
  String winner = "";
  String roomID = "";
  String player1 = "";
  String player2 = "";
  String status = "";
  String test = "test";
  static bool _isInitialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // if(_isInitialized){
    //   return;
    // }
    final args = ModalRoute.of(context)!.settings.arguments as GameData;
    roomID = args.roomID;
    isPlayer1 = args.isPlayer1;
    _isInitialized = true;  
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    readData();
    return Scaffold(
      appBar: AppBar(
        title: const Text("井字遊戲"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("房間ID: $roomID"),
            Text("玩家1: $player1"),
            Text("玩家2: $player2"),
            Text("遊戲狀態: $status"),
            Text("輪到玩家: ${player1Move ? player1 : player2}"),
            for(int i = 0 ; i < 3 ; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for(int j = 0 ; j < 3 ; j++)
                    GestureDetector(
                      onTap: (){
                        if(isGameOver){
                          return;
                        }
                        if(board[i][j] == "" && player1Move == isPlayer1){
                          setState(() {
                            if(isPlayer1){
                              board[i][j] = "X";
                            }else{
                              board[i][j] = "O";
                            }
                            player1Move = !player1Move;
                            checkWinner();
                            dbRef.child("rooms").child(roomID).update({
                              "board": board,
                              "player1Move": player1Move,
                              "isGameOver": isGameOver,
                              "winner": winner,
                            });
                          });
                        }
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: Text(board[i][j]),
                        ),
                      ),
                    )
                ],
              ),
            if(isGameOver)
              Text("Winner: $winner"),
          ],
        ),
      ),
    );
  }
  void checkWinner(){
    for(int i = 0 ; i < 3 ; i++){
      if(board[i][0] == board[i][1] && board[i][1] == board[i][2] && board[i][0] != ""){
        setState(() {
          isGameOver = true;
          winner = board[i][0];
        });
      }

      if(board[0][i] == board[1][i] && board[1][i] == board[2][i] && board[0][i] != ""){
        setState(() {
          isGameOver = true;
          winner = board[0][i];
        });
      }

      if(board[0][0] == board[1][1] && board[1][1] == board[2][2] && board[0][0] != ""){
        setState(() {
          isGameOver = true;
          winner = board[0][0];
        });
      }

      if(board[0][2] == board[1][1] && board[1][1] == board[2][0] && board[0][2] != ""){
        setState(() {
          isGameOver = true;
          winner = board[0][2];
        });
      }

      bool isDraw = true;
      for(int i = 0 ; i < 3 ; i++){
        for(int j = 0 ; j < 3 ; j++){
          if(board[i][j] == ""){
            isDraw = false;
          }
        }
      }
      if(isDraw){
        setState(() {
          isGameOver = true;
          winner = "Draw";
        });
      }

      if(isGameOver){
        Map<String, dynamic> data = {
          "roomID": roomID,
          "player1": player1,
          "player2": player2,
          "status": "end",
          "board": board,
          "player1Move": player1Move,
          "isGameOver": isGameOver,
          "winner": winner,
        };
        dbRef.child("rooms").child(roomID).set(data);
      }
    }
  }
  void readData(){

    dbRef.child("rooms").child(roomID).onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<dynamic, dynamic> values = dataSnapshot.value as Map<dynamic, dynamic>;
      setState(() {
        player1 = values["player1"];
        player2 = values["player2"];
        roomID = values["roomID"];
        status = values["status"];
        for(int i = 0 ; i < 3 ; i++){
          for(int j = 0 ; j < 3 ; j++){
            board[i][j] = values["board"][i][j] ?? "";
          }
        }
        player1Move = values["player1Move"];
        isGameOver = values["isGameOver"];
        winner = values["winner"] ?? "";
      });
    });
  }
}
