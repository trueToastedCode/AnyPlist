import 'package:anyplist/ui/pages/open/router/open_router_contract.dart';
import 'package:anyplist/ui/widgets/open/open_widget.dart';
import 'package:anyplist/ui/widgets/open/version_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../states_management/open/open_cubit.dart';
import '../../../states_management/open/open_state.dart';

class OpenPage extends StatefulWidget {
  final IOpenRouter router;

  const OpenPage({Key? key, required this.router}) : super(key: key);

  @override
  State<OpenPage> createState() => _OpenPageState();
}

class _OpenPageState extends State<OpenPage> {

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
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8, right: 8),
                    child: VersionWidget(),
                  )
                ],
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
}
