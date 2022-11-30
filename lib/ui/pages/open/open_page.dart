import 'dart:html' as html;

import 'package:anyplist/services/adblock_detection/adblock_detection_impl.dart';
import 'package:anyplist/ui/pages/open/router/open_router_contract.dart';
import 'package:anyplist/ui/widgets/open/open_widget.dart';
import 'package:anyplist/ui/widgets/open/version_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../states_management/open/open_cubit.dart';
import '../../../states_management/open/open_state.dart';
import '../../widgets/open/author_widget.dart';

class OpenPage extends StatefulWidget {
  final IOpenRouter router;

  const OpenPage({Key? key, required this.router}) : super(key: key);

  @override
  State<OpenPage> createState() => _OpenPageState();
}

class _OpenPageState extends State<OpenPage> {

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          children: [
            Expanded(child: Container()),
            BlocConsumer<OpenCubit, OpenState>(
              builder: (_, state) {
                return OpenWidget(
                  enabled: state is OpenInitialState,
                  open: () => context.read<OpenCubit>().open(),
                  newplist: () => context.read<OpenCubit>().newplist(),
                );
              },
              listener: (_, state) {
                if (state is OpenSuccessState) {
                  widget.router.onOpenSuccess(context, state.anyXML);
                } else if (state is OpenFailureState) {
                  _failure(state.message);
                  context.read<OpenCubit>().reset();
                }
              },
            ),
            const SizedBox(height: 20),
            Container(
              width: 350,
              padding: const EdgeInsets.fromLTRB(7, 5, 8, 7),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'AnyPlist is a Flutter based free editor for Property lists',
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(child: Container()),
                    const Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: AuthorWidget(),
                      ),
                    ),
                    const Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: VersionWidget(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _failure(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Failure'),
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  _adBlocker() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('AdBlocker Detected'),
          content: SingleChildScrollView(
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: '🦄 This website is free to use 🦄.',
                    style: TextStyle(color: Colors.green),
                  ),
                  TextSpan(
                    text: ' However hosting it, is not. Therefore ads make this side possible. Please disable you\'re Adblocker.',
                    style: TextStyle(color: Colors.red),
                  ),
                ]
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => html.window.location.reload(),
              child: const Text('💪 I\'ve disabled 💪'),
            ),
          ],
        );
      },
    );
  }

   _init() async {
     try {
       if (!await AdblockDetection().isBocked()) return;
     } on Exception catch(_) {
       return;
     }
     await Future.delayed(const Duration(seconds: 1));
     _adBlocker();
  }
}
