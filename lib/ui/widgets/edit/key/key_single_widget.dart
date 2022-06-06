import 'package:anyplist/ui/widgets/edit/bool_widget.dart';
import 'package:anyplist/ui/widgets/edit/data_widget.dart';
import 'package:anyplist/ui/widgets/edit/type_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../states_management/edit/edit_cubit.dart';
import '../add_remove_widget.dart';
import '../date_widget.dart';
import '../number_widget.dart';
import '../string_widget.dart';
import '../../../../globals.dart' as globals;
import '../up_down_widget.dart';

class KeySingleWidget extends StatefulWidget {
  final List<dynamic> path;
  final int indent;
  final Function update;

  const KeySingleWidget({Key? key, required this.path, required this.indent, required this.update}) : super(key: key);

  @override
  State<KeySingleWidget> createState() => _KeySingleWidgetState();
}

class _KeySingleWidgetState extends State<KeySingleWidget> {
  late final List<dynamic> _keyPath, _childTypePath, _contentPath, _firstContentPath;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          SizedBox(
            width: 300 - widget.indent * 20 + 3.5,
            child: Padding(
              padding: const EdgeInsets.only(right: 2),
              child: StringWidget(
                path: _keyPath,
                update: widget.update,
              ),
            ),
          ),
          AddRemoveWidget(
            path: widget.path,
            update: widget.update,
            withKey: true,
          ),
          const SizedBox(width: 3),
          SizedBox(
            width: 120,
            child: TypeWidget(
              update: widget.update,
              path: _firstContentPath,
            ),
          ),
          globals.isMobile
              ? Padding(
                  padding: const EdgeInsets.only(right: 3.0),
                  child: UpDownWidget(update: widget.update, path: widget.path),
                )
              : Container(),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: _child(),
            ),
          ),
        ],
      ),
    );
  }

  _child() {
    switch (_childType()) {
      case 'data':
        return DataWidget(path: _contentPath, update: widget.update);
      case 'bool':
        return BoolWidget(path: _contentPath, update: widget.update);
      case 'integer':
        return NumberWidget(path: _contentPath, update: widget.update);
      case 'date':
        return DateWidget(path: _contentPath, update: widget.update);
      default:
        return StringWidget(path: _contentPath, update: widget.update);
    }
  }

  _childType() {
    return context.read<EditCubit>().editViewModel.anyXML.getPath(_childTypePath);
  }

  _init() {
    _contentPath = List.from(widget.path)..addAll(['content', 'content']);
    _keyPath = List.from(widget.path)..add('key');
    _childTypePath = List.from(widget.path)..addAll(['content', 'type']);
    _firstContentPath = List.from(widget.path)..addAll(['content']);
  }
}
