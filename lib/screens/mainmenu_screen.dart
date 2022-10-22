import 'dart:js';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:go_router/go_router.dart';
import 'package:multi_player_tictactoe/screens/join_room_screen.dart';
import '../responsive/responsiveness.dart';
import '../widgets/custom_button.dart';
import 'creating_room_screen.dart';

class MainMenuScreen extends StatelessWidget {
  static const String routeName = "/main_menu";
  const MainMenuScreen({Key? key}) : super(key: key);

  void createRoom(BuildContext context) {
    context.go(CreateRoom.routeName);
  }

  void joinRoom(BuildContext context) {
    context.go(JoinRoom.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              onTap: () => createRoom(context),
              text: 'Create Room',
            ),
            const SizedBox(height: 20),
            CustomButton(
              onTap: () => joinRoom(context),
              text: 'Join Room',
            ),
          ],
        ),
      ),
    );
  }
}
