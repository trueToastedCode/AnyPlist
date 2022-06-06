import 'package:flutter/material.dart';

class ReorderSeparatorWidget extends StatelessWidget {
  const ReorderSeparatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(color: Colors.blueAccent, width: 1),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.blueAccent
          ),
        )
      ],
    );
  }
}
