import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget child;
  const Responsive({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child:
            //ConstrainedBox imposes additional constraints on its child
            ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: child,
    ));
  }
}
