import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:multi_player_tictactoe/responsive/responsiveness.dart';
import 'package:multi_player_tictactoe/widgets/custom_textfied.dart';
import 'package:provider/provider.dart';

import '../providers/provider.dart';

class WaitingWidget extends StatefulWidget {
  const WaitingWidget({Key? key}) : super(key: key);

  @override
  State<WaitingWidget> createState() => _WaitingWidgetState();
}

class _WaitingWidgetState extends State<WaitingWidget> {
  late TextEditingController _roomIdController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _roomIdController = TextEditingController(
        text: Provider.of<RoomProvider>(context, listen: false)
            .getRoomData['_id']);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _roomIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Waiting for a player to join...'),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _roomIdController,
            hintText: '',
            isReadOnly: true,
          ),
        ],
      ),
    );
  }
}
