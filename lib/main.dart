import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_player_tictactoe/providers/provider.dart';
// import 'package:dotenv/dotenv.dart';
import 'package:multi_player_tictactoe/screens/creating_room_screen.dart';
import 'package:multi_player_tictactoe/screens/game_screen.dart';
import 'package:multi_player_tictactoe/screens/join_room_screen.dart';
import 'package:multi_player_tictactoe/utils/colors.dart';
import 'package:go_router/go_router.dart';

import 'screens/mainmenu_screen.dart';

// DotEnv? env;
void main() {
  // env = DotEnv(includePlatformEnvironment: true)..load();
  // print(env!["IP_ADDRESS"]);
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => RoomProvider()),
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      routeInformationProvider: _router.routeInformationProvider,
      title: 'Flutter Demo',
      theme:
          ThemeData.dark().copyWith(scaffoldBackgroundColor: backgroundColor),
    );
  }

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const MainMenuScreen();
        },
      ),
      GoRoute(
        path: CreateRoom.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const CreateRoom();
        },
      ),
      GoRoute(
        path: JoinRoom.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const JoinRoom();
        },
      ),
      GoRoute(
        path: GameScreen.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const GameScreen();
        },
      ),
    ],
  );
}
