import 'package:flutter/material.dart';

class ExpansionThemeWidget extends StatelessWidget {
  final Widget child;

  const ExpansionThemeWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ListTileTheme(
        contentPadding: const EdgeInsets.all(0),
        dense: true,
        horizontalTitleGap: 8.0,
        minLeadingWidth: 0,
        child: child,
      ),
    );
  }
}
