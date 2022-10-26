import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_player_tictactoe/providers/provider.dart';
import 'package:multi_player_tictactoe/resources/game_methods.dart';
import 'package:multi_player_tictactoe/resources/socket_client.dart';
import 'package:multi_player_tictactoe/screens/game_screen.dart';
import 'package:multi_player_tictactoe/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketMethods {
  final _socketClient = SocketClient.getInstance.socket!;

  Socket get socketClient => _socketClient;

  void createRoom(String name) {
    if (name.isNotEmpty) {
      //.emit is used to send data to the server, with the 1st argument being the event
      //while the second is the data
      _socketClient.emit('createRoom', {
        'nickname': name,
      });
      print(name);
    }
  }

  void createRoomSuccessListener(BuildContext context) {
    _socketClient.on("createdRoomSuccess", (room) {
      Provider.of<RoomProvider>(context, listen: false).updateRoomData(room);
      context.go(GameScreen.routeName);
    });
  }

  void joinRoom(String nickname, String roomId) {
    if (nickname.isNotEmpty && roomId.isNotEmpty) {
      //send data to the io
      _socketClient.emit('joinRoom', {
        'nickname': nickname,
        'roomId': roomId,
      });
    }
  }

  void joinRoomSuccessListener(BuildContext context) {
    _socketClient.on('joinRoomSuccess', (room) {
      Provider.of<RoomProvider>(context, listen: false).updateRoomData(room);
      context.go(GameScreen.routeName);
    });
  }

  void errorOccuredListener(BuildContext context) {
    _socketClient.on("errorOcuured", (data) {
      showSnackBar(context, data);
    });
  }

  void updatePlayersStateListener(BuildContext context) {
    _socketClient.on("updatePlayers", (data) {
      Provider.of<RoomProvider>(context, listen: false).updatePlayer1(data[0]);
      Provider.of<RoomProvider>(context, listen: false).updatePlayer2(data[1]);
    });
  }

  //ensure the waiting screen refreshes to the game screen
  void updateRoomListener(BuildContext context) {
    _socketClient.on("updateRoom", (data) {
      Provider.of<RoomProvider>(context, listen: false).updateRoomData(data);
    });
  }

  //ensure tapping occurs on only empty grid
  void tapGrid(int index, String roomId, List<String> displayElements) {
    if (displayElements[index] == '') {
      _socketClient.emit('tap', {
        'index': index,
        'roomId': roomId,
      });
    }
  }

  //listen to taps and upate data accordingly
  void tappedListener(BuildContext context) {
    _socketClient.on("tapped", (data) {
      RoomProvider roomProvider =
          Provider.of<RoomProvider>(context, listen: false);
      //update displays Elements
      roomProvider.updateDisplayElements(data['index'], data['choice']);
      //update room data
      roomProvider.updateRoomData(data['room']);
      //check for winner
      GameMethods().checkWinner(context, _socketClient);
    });
  }

  void pointIncreaseListener(BuildContext context) {
    //listen to the pointIncrease emmitter
    _socketClient.on('pointsIncrease', (playerData) {
      var roomDataProvider = Provider.of<RoomProvider>(context, listen: false);
      //update player data accordingly
      if (playerData['socketID'] == roomDataProvider.player1.socketID) {
        roomDataProvider.updatePlayer1(playerData);
      } else {
        roomDataProvider.updatePlayer2(playerData);
      }
    });
  }

  void endGameListener(BuildContext context) {
    _socketClient.on('endGame', (playerData) {
      showGameDialog(context, '${playerData['nickname']} won the game!');
      Navigator.popUntil(context, (route) => false);
    });
  }
}
