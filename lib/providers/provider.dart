import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/player.dart';
import '../resources/socket_methods.dart';

// final roomControolerProvider = Provider((ref) {
//   // final sockMethods = ref.read(socketMethodProvider);
//   return RoomControoler().updataRoomData()
// });

class RoomProvider extends ChangeNotifier {
  Map<String, dynamic> _roomData = {};
  List<String> _displayElements = [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  ];

  int _filledBoxes = 0;

  List<String> get displayElements => _displayElements;
  int get filledBoxes => _filledBoxes;

  var _player1 = Player(nickname: "", socketID: "", points: 0, playerType: "X");

  var _player2 = Player(nickname: "", socketID: "", points: 0, playerType: "O");

  Player get player1 => _player1;
  Player get player2 => _player2;

  Map<String, dynamic> get getRoomData => _roomData;

  void updateRoomData(Map<String, dynamic> data) {
    _roomData = data;
    notifyListeners();
  }

  void updatePlayer1(Map<String, dynamic> player1Data) {
    _player1 = Player.fromMap(player1Data);
    print("... player1 is ...$_player1");
    notifyListeners();
  }

  void updatePlayer2(Map<String, dynamic> player2Data) {
    _player2 = Player.fromMap(player2Data);
    print(_player2);
    notifyListeners();
  }

  void updateDisplayElements(int index, String choice) {
    _displayElements[index] = choice;
    _filledBoxes += 1;
    notifyListeners();
  }

  void setFilledBoxesTo0() {
    _filledBoxes = 0;
    notifyListeners();
  }
}
