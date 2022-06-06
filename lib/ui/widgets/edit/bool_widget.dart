import 'package:anyplist/states_management/edit/edit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoolWidget extends StatefulWidget {
  final List<dynamic> path;
  final Function update;

  const BoolWidget({Key? key, required this.path, required this.update}) : super(key: key);

  @override
  State<BoolWidget> createState() => _BoolWidgetState();
}

class _BoolWidgetState extends State<BoolWidget> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    _correct();
    return Checkbox(
      activeColor: Colors.blue,
      value: _value,
      onChanged: (value) => _change(value!),
    );
  }

  _rawToView(String data) {
    switch (data) {
      case 'false': return false;
      case 'true': return true;
      default: throw Exception('Invalid bool data');
    }
  }

  _viewToRaw(bool value) {
    return value ? 'true' : 'false';
  }

  _correct() {
    final reading = _rawToView(context.read<EditCubit>().editViewModel.anyXML.getPath(widget.path));
    if (reading != _value) {
      _value = reading;
    }
  }

  _change(bool value) {
    final editCubit = context.read<EditCubit>();
    final valueBefore = _value;
    final valueNow = value;
    editCubit.editViewModel.anyXML.setPath(widget.path, _viewToRaw(valueNow));
    _value = value;
    widget.update();
    editCubit.addUndo(
        '[${widget.path.join(' → ')}] Change bool from "${_viewToRaw(valueBefore)}" to "${_viewToRaw(valueNow)}"',
          () {
            editCubit.editViewModel.anyXML.setPath(widget.path, _viewToRaw(valueBefore));
            widget.update();
          },
          () {
            editCubit.editViewModel.anyXML.setPath(widget.path, _viewToRaw(value));
            widget.update();
          });
  }
}
