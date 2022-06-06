import 'package:anyplist/ui/widgets/edit/array_plist_dict_widget.dart';
import 'package:anyplist/ui/widgets/edit/key/key_widget.dart';
import 'package:anyplist/ui/widgets/edit/other_widget.dart';
import 'package:anyplist/ui/widgets/edit/single_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../states_management/edit/edit_cubit.dart';
import 'indent_padding.dart';

class TreeBuilder {
  List<Widget> buildWidgets(BuildContext context, List<dynamic> path, int indent, Function update) {
    final widgets = <Widget>[];
    final elements = context.read<EditCubit>().editViewModel.anyXML.getPath(path);
    for (int i=0; i<elements.length; i++) {
      final currentPath = List<dynamic>.from(path)..add(i);
      final widget = _buildWidget(context, currentPath, indent, update);
      widgets.add(widget);
    }
    return widgets;
  }

  Widget _buildWidget(BuildContext context, List<dynamic> path, int indent, Function update) {
    final element = context.read<EditCubit>().editViewModel.anyXML.getPath(path);
    final type = element['type'];
    if (type == null || type.runtimeType != String || type.isEmpty) {
      throw Exception('Undefined type');
    }
    switch (type) {
      case 'array':
      case 'plist':
      case 'dict':
        return IndentPadding(
          indent: indent,
          child: ArrayPlistDictWidget(indent: indent, path: path, update: update));
      case 'key':
        return IndentPadding(
          indent: indent,
          child: KeyWidget(indent: indent, path: path, update: update));
      case 'other':
        return IndentPadding(
          indent: indent,
          child: OtherWidget(path: path));
      default:
        return IndentPadding(
          indent: indent,
          child: SingleWidget(path: path, indent: indent, update: update));
    }
  }
}
