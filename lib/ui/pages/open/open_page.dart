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
                'AnyPlist is a free editor based on Flutter for Property lists.',
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
}
