import 'package:multi_player_tictactoe/private_props.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:multi_player_tictactoe/main.dart';

//Responsible for direction communication with the socket stream
class SocketClient {
  IO.Socket? socket;
  static SocketClient? _instance;

  //private constructor of the SocketClient objects
  SocketClient._internal() {
    socket = IO.io("http://$API_ADDRESS:3000", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket!.connect();
  }

  static SocketClient get getInstance {
    //Assign the value only if it is null.
    _instance ??= SocketClient._internal();
    return _instance!;
  }
}
