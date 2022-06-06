import 'package:flutter/material.dart';

class ReorderFeedbackWidget extends StatelessWidget {
  const ReorderFeedbackWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.6),
      ),
    );
  }
}
