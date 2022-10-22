import 'package:flutter/material.dart';
import 'package:multi_player_tictactoe/screens/creating_room_screen.dart';
import 'package:multi_player_tictactoe/screens/join_room_screen.dart';
import 'package:multi_player_tictactoe/utils/colors.dart';
import 'package:go_router/go_router.dart';

import 'screens/mainmenu_screen.dart';

void main() {
  runApp(MyApp());
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
    ],
  );
}
