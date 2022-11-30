import 'package:anyplist/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../states_management/edit/edit_cubit.dart';

class TypeWidget extends StatefulWidget {
  final List<dynamic> path;
  final Function update;

  const TypeWidget({Key? key, required this.path, required this.update}) : super(key: key);

  @override
  State<TypeWidget> createState() => _TypeWidgetState();
}

class _TypeWidgetState extends State<TypeWidget> {
  late final List<dynamic> _typePath;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return _type() == 'plist'
        ? const Text('plist', style: TextStyle(fontSize: typeFontSize))
        : DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _type(),
              onChanged: _convert,
              items: <String>['dict', 'array', 'string', 'integer', 'data', 'bool', 'date']
                  .map<DropdownMenuItem<String>>((String type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type, style: const TextStyle(fontSize: typeFontSize)),
                );
              }).toList(),
            ),
          );
  }

  _convert(String? newType) {
    if (newType == null || newType == _type()) return;
    final editCubit = context.read<EditCubit>();
    final valueBefore = editCubit.editViewModel.anyXML.getPath(widget.path);
    final typeBefore = _type();
    editCubit.editViewModel.anyXML.convert(widget.path, newType);
    final valueAfter = editCubit.editViewModel.anyXML.getPath(widget.path);
    editCubit.addUndo(
        '[${widget.path.join(' → ')}] Convert $typeBefore to $newType',
        () {
          editCubit.editViewModel.anyXML.setPath(widget.path, valueBefore);
          widget.update();
        },
        () {
          editCubit.editViewModel.anyXML.setPath(widget.path, valueAfter);
          widget.update();
        });
    widget.update();
  }

  _type () {
    return context.read<EditCubit>().editViewModel.anyXML.getPath(_typePath);
  }

  _init() {
    _typePath = List.from(widget.path)..add('type');
  }
}
