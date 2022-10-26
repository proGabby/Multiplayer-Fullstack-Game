import 'package:flutter/material.dart';
import 'package:multi_player_tictactoe/providers/provider.dart';
import 'package:multi_player_tictactoe/widgets/score_board_widget.dart';
import 'package:multi_player_tictactoe/widgets/tictactoe_board_widget.dart';
import 'package:provider/provider.dart';

import '../widgets/waiting_widget.dart';
import '../resources/socket_methods.dart';

class GameScreen extends StatefulWidget {
  static const routeName = "/gamescreen";
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final SocketMethods _socketMethod = SocketMethods();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _socketMethod.joinRoomSuccessListener(context);
    _socketMethod.errorOccuredListener(context);
    _socketMethod.updatePlayersStateListener(context);
    print("inside join gamescreen initstate");
    _socketMethod.updateRoomListener(context);
    _socketMethod.pointIncreaseListener(context);
    _socketMethod.endGameListener(context);
  }

  @override
  Widget build(BuildContext context) {
    var roomDataProvider = Provider.of<RoomProvider>(context);
    return Scaffold(
      body: roomDataProvider.getRoomData['isJoin']
          ? const WaitingWidget()
          : SafeArea(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Scoreboard(),
                const TicTacToeBoard(),
                Text(
                    '${roomDataProvider.getRoomData['turn']['nickname']}\'s turn'),
              ],
            )),
    );
  }
}
