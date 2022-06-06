import 'package:flutter/material.dart';

import 'composition_root.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CompositionRoot.configure();
  final firstPage = CompositionRoot.start();
  runApp(Main(firstPage: firstPage));
}

class Main extends StatelessWidget {
  final Widget firstPage;

  const Main({Key? key, required this.firstPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnyPlist',
      theme: lightTheme(context),
      darkTheme: darkTheme(context),
      home: firstPage,
    );
  }
}
