import 'package:anyplist/states_management/edit/edit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberWidget extends StatefulWidget {
  final List<dynamic> path;
  final Function update;

  const NumberWidget({Key? key, required this.path, required this.update}) : super(key: key);

  @override
  State<NumberWidget> createState() => _NumberWidgetState();
}

class _NumberWidgetState extends State<NumberWidget> {
  final _controller = TextEditingController();
  String? _textBefore;
  final _focusNode = FocusNode();

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
        hintText: "number",
        contentPadding: EdgeInsets.only(top: 17, right: 0),
      ),
      style: const TextStyle(fontSize: 12),
      textAlignVertical: TextAlignVertical.bottom,
      controller: _controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
      ],
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
        _change();
      }
    }
    setState(() {});
  }

  _change() {
    final editCubit = context.read<EditCubit>();
    editCubit.editViewModel.anyXML.setPath(widget.path, _controller.text);
    final textBefore = _textBefore == null ? '' : String.fromCharCodes(_textBefore!.codeUnits);
    final textNow = String.fromCharCodes(_controller.text.codeUnits);
    editCubit.addUndo(
        '[${widget.path.join(' → ')}] Change number from "$textBefore" to "$textNow"',
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
