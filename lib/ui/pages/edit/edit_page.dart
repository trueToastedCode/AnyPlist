import 'dart:io' show Platform;
import 'dart:js' as js;

import 'package:anyplist/states_management/edit/edit_cubit.dart';
import 'package:anyplist/states_management/edit/edit_state.dart';
import 'package:anyplist/ui/pages/edit/router/edit_router_contract.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../edit/safe_data/safe_data_ios.dart';
import '../../widgets/edit/tree_builder.dart';
import 'safe_data/safe_data_web.dart';

class EditPage extends StatefulWidget {
  final IEditRouter router;
  
  const EditPage({Key? key, required this.router}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _treeBuilder = TreeBuilder();

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<EditCubit, EditState>(
          builder: (_, state) {
            if (state is EditInitialState) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: _undo,
                        child: const Text('Undo'),
                      ),
                      TextButton(
                        onPressed: _redo,
                        child: const Text('Redo'),
                      ),
                      TextButton(
                        onPressed: _save,
                        child: const Text('Save'),
                      ),
                      TextButton(
                        onPressed: _leave,
                        child: const Text('Leave'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      children: _treeBuilder.buildWidgets(context, [], 0, () => setState(() {})),
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  _undo() {
    final description = context.read<EditCubit>().undo();
    if (description == null) return;
    _undoRedoDialog('Undone', description);
  }

  _redo() {
    final description = context.read<EditCubit>().redo();
    if (description == null) return;
    _undoRedoDialog('Redone', description);
  }

  _undoRedoDialog(String action, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(action),
          content: SingleChildScrollView(
            child: Text(description),
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

  _save() async {
    final data = context.read<EditCubit>().editViewModel.anyXML.compile();
    final controller = TextEditingController();
    controller.text = 'MyPlist.plist';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Material(
            color: Colors.transparent,
            child: TextFormField(
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: "filename",
                contentPadding: EdgeInsets.only(top: 17, right: 0),
              ),
              style: const TextStyle(fontSize: 12),
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.center,
              controller: controller,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isEmpty) return;
                if (kIsWeb) {
                  SafeDataWeb().safe(data, controller.text);
                } else if (Platform.isIOS) {
                  SafeDataIOS().safe(data, controller.text);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Safe'),
            ),
          ],
        );
      },
    );
  }
  
  _leave() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Leave'),
          content: const Text('Do you really want to leave?'),
          actions: [
            TextButton(
              onPressed: () => widget.router.onLeave(context),
              child: const Text('Yes', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            )
          ],
        );
      },
    );
  }

  _init() {
    js.context.callMethod('interstitialAd');
  }
}
