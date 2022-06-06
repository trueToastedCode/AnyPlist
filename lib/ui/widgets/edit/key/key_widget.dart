import 'package:anyplist/ui/widgets/edit/key/key_single_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../states_management/edit/edit_cubit.dart';
import 'key_array_plist_dict_widget.dart';

class KeyWidget extends StatelessWidget {
  final int indent;
  final List<dynamic> path;
  final Function update;

  const KeyWidget({Key? key, required this.indent, required this.path, required this.update}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ['array', 'plist', 'dict'].contains(_childType(context))
        ? KeyArrayPlistDictWidget(path: path, indent: indent, update: update)
        : KeySingleWidget(path: path, indent: indent, update: update);
  }

  _childType(BuildContext context) {
    return context.read<EditCubit>().editViewModel.anyXML
        .getPath(List.from(path)
            ..addAll(['content', 'type']));
  }
}
