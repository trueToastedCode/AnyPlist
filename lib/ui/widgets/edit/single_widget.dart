import 'package:anyplist/ui/widgets/edit/data_widget.dart';
import 'package:anyplist/ui/widgets/edit/date_widget.dart';
import 'package:anyplist/ui/widgets/edit/type_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../states_management/edit/edit_cubit.dart';
import 'add_remove_widget.dart';
import 'bool_widget.dart';
import 'number_widget.dart';
import 'string_widget.dart';
import 'up_down_widget.dart';
import '../../../globals.dart' as globals;

class SingleWidget extends StatefulWidget {
  final List<dynamic> path;
  final int indent;
  final Function update;

  const SingleWidget({Key? key, required this.path, required this.indent, required this.update}) : super(key: key);

  @override
  State<SingleWidget> createState() => _SingleWidgetState();
}

class _SingleWidgetState extends State<SingleWidget> {
  late final List<dynamic> _contentPath, _typePath;

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 300 - widget.indent * 20,
            child: Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Align(
                alignment: Alignment.centerLeft,
                child: _child(),
              ),
            ),
          ),
          AddRemoveWidget(
            path: widget.path,
            update: widget.update,
          ),
          const SizedBox(width: 3),
          SizedBox(
            width: 120,
            child: TypeWidget(
              update: widget.update,
              path: widget.path,
            ),
          ),
          globals.isMobile
              ? Padding(
                  padding: const EdgeInsets.only(right: 3.0),
                  child: UpDownWidget(update: widget.update, path: widget.path),
                )
              : Container(),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  _child() {
    switch (_type()) {
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

  _type() {
    return context.read<EditCubit>().editViewModel.anyXML.getPath(_typePath);
  }

  _init() {
    _contentPath = List.from(widget.path)..add('content');
    _typePath = List.from(widget.path)..add('type');
  }
}
