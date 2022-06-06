import 'package:anyplist/states_management/edit/edit_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DateWidget extends StatefulWidget {
  final List<dynamic> path;
  final Function update;

  const DateWidget({Key? key, required this.path, required this.update}) : super(key: key);

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  final _controller = TextEditingController();
  String? _textBefore;
  final _focusNode = FocusNode();

  static final _regExp = RegExp(r'[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])T(2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]Z');

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _correct();
    return TextFormField(
      focusNode: _focusNode,
      maxLines: 1,
      decoration: const InputDecoration(
        isDense: true,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        hintText: "date",
        contentPadding: EdgeInsets.only(top: 17, right: 0),
      ),
      style: const TextStyle(fontSize: 12),
      textAlignVertical: TextAlignVertical.bottom,
      controller: _controller,
    );
  }

  _correct() {
    final reading = context.read<EditCubit>().editViewModel.anyXML.getPath(widget.path);
    if (reading != _controller.text) {
      _controller.text = reading;
    }
  }

  _focusChange() {
    if (_focusNode.hasFocus) {
      _textBefore = _controller.text;
    } else {
      if (_textBefore != _controller.text) {
        if (!_regExp.hasMatch(_controller.text)) {
          _wrong();
          _controller.text = _textBefore ?? '';
        } else {
          _change();
        }
      }
    }
    setState(() {});
  }

  _wrong() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Invalid format', textAlign: TextAlign.center),
          content: const Text('Example for valid entry: 2007-06-29T09:41:00Z'),
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

  _change() {
    final editCubit = context.read<EditCubit>();
    editCubit.editViewModel.anyXML.setPath(widget.path, _controller.text);
    final textBefore = _textBefore == null ? '' : String.fromCharCodes(_textBefore!.codeUnits);
    final textNow = String.fromCharCodes(_controller.text.codeUnits);
    editCubit.addUndo(
        '[${widget.path.join(' → ')}] Change text from "$textBefore" to "$textNow"',
            () {
          editCubit.editViewModel.anyXML.setPath(widget.path, textBefore);
          widget.update();
        },
            () {
          editCubit.editViewModel.anyXML.setPath(widget.path, textNow);
          widget.update();
        });
    _resetTextBefore();
  }

  _resetTextBefore() {
    _textBefore = null;
  }

  _init() {
    _focusNode.addListener(_focusChange);
  }
}
