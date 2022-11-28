import 'package:flutter/material.dart';

class AuthorWidget extends StatelessWidget {
  const AuthorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SelectableText(
      'Contact? truetoastedcode@gmail.com',
      style: TextStyle(color: Colors.white70),
    );
  }
}
