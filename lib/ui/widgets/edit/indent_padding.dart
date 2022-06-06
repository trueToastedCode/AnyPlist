import 'package:flutter/cupertino.dart';

class IndentPadding extends StatelessWidget {
  final int indent;
  final Widget child;

  const IndentPadding({Key? key, required this.indent, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: indent == 0 ? 0 : 20),
      child: child,
    );
  }
}