import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../providers/provider.dart';
import '../utils/utils.dart';

class GameMethods {
  //check for winner of the game
  void checkWinner(BuildContext context, Socket socketClent) {
    RoomProvider roomDataProvider =
        Provider.of<RoomProvider>(context, listen: false);

    String winner = '';

    // Checking rows
    if (roomDataProvider.displayElements[0] ==
            roomDataProvider.displayElements[1] &&
        roomDataProvider.displayElements[0] ==
            roomDataProvider.displayElements[2] &&
        roomDataProvider.displayElements[0] != '') {
      winner = roomDataProvider.displayElements[0];
    }
    if (roomDataProvider.displayElements[3] ==
            roomDataProvider.displayElements[4] &&
        roomDataProvider.displayElements[3] ==
            roomDataProvider.displayElements[5] &&
        roomDataProvider.displayElements[3] != '') {
      winner = roomDataProvider.displayElements[3];
    }
    if (roomDataProvider.displayElements[6] ==
            roomDataProvider.displayElements[7] &&
        roomDataProvider.displayElements[6] ==
            roomDataProvider.displayElements[8] &&
        roomDataProvider.displayElements[6] != '') {
      winner = roomDataProvider.displayElements[6];
    }

    // Checking Column
    if (roomDataProvider.displayElements[0] ==
            roomDataProvider.displayElements[3] &&
        roomDataProvider.displayElements[0] ==
            roomDataProvider.displayElements[6] &&
        roomDataProvider.displayElements[0] != '') {
      winner = roomDataProvider.displayElements[0];
    }
    if (roomDataProvider.displayElements[1] ==
            roomDataProvider.displayElements[4] &&
        roomDataProvider.displayElements[1] ==
            roomDataProvider.displayElements[7] &&
        roomDataProvider.displayElements[1] != '') {
      winner = roomDataProvider.displayElements[1];
    }
    if (roomDataProvider.displayElements[2] ==
            roomDataProvider.displayElements[5] &&
        roomDataProvider.displayElements[2] ==
            roomDataProvider.displayElements[8] &&
        roomDataProvider.displayElements[2] != '') {
      winner = roomDataProvider.displayElements[2];
    }

    // Checking Diagonal
    if (roomDataProvider.displayElements[0] ==
            roomDataProvider.displayElements[4] &&
        roomDataProvider.displayElements[0] ==
            roomDataProvider.displayElements[8] &&
        roomDataProvider.displayElements[0] != '') {
      winner = roomDataProvider.displayElements[0];
    }
    if (roomDataProvider.displayElements[2] ==
            roomDataProvider.displayElements[4] &&
        roomDataProvider.displayElements[2] ==
            roomDataProvider.displayElements[6] &&
        roomDataProvider.displayElements[2] != '') {
      winner = roomDataProvider.displayElements[2];
    } else if (roomDataProvider.filledBoxes == 9) {
      winner = '';
      showGameDialog(context, 'Draw');
    }
    print("winner is ${winner}");

    if (winner != '') {
      final roomData = Provider.of<RoomProvider>(context, listen: false);
      if (roomDataProvider.player1.playerType == winner) {
        showGameDialog(context, '${roomData.player1.nickname} won!');
        //send message to the socket
        print("inside winner socket, sockerId is ${roomData.player1.socketID}");
        socketClent.emit('winner', {
          'winnerSocketId': roomData.player1.socketID,
          'roomId': roomData.getRoomData['_id'],
        });
      } else {
        showGameDialog(context, '${roomData.player2.nickname} won!');
        socketClent.emit('winner', {
          'winnerSocketId': roomData.player2.socketID,
          'roomId': roomData.getRoomData['_id'],
        });
      }
    }
  }

  //ensure board is clear when game is restarted
  void clearBoard(BuildContext context) {
    RoomProvider roomDataProvider =
        Provider.of<RoomProvider>(context, listen: false);

    for (int i = 0; i < roomDataProvider.displayElements.length; i++) {
      roomDataProvider.updateDisplayElements(i, '');
    }
    roomDataProvider.setFilledBoxesTo0();
  }
}
