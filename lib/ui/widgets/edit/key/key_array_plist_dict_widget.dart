import 'dart:math';
import 'dart:io' show Platform;

import 'package:anyplist/states_management/edit/edit_cubit.dart';
import 'package:anyplist/ui/widgets/edit/type_widget.dart';
import 'package:anyplist/ui/widgets/edit/up_down_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/widget_drag_reorder_module/widget_drag_reorder_module_mouse.dart';
import '../../../../models/widget_drag_reorder_module/widget_drag_reorder_module_contract.dart';
import '../add_remove_widget.dart';
import '../expansion_theme_widget.dart';
import '../string_widget.dart';
import '../tree_builder.dart';
import '../../../../globals.dart' as globals;

class KeyArrayPlistDictWidget extends StatefulWidget {
  final List<dynamic> path;
  final int indent;
  final Function update;

  const KeyArrayPlistDictWidget({Key? key, required this.path, required this.indent, required this.update}) : super(key: key);

  @override
  State<KeyArrayPlistDictWidget> createState() => _KeyArrayPlistDictWidgetState();
}

class _KeyArrayPlistDictWidgetState extends State<KeyArrayPlistDictWidget> with TickerProviderStateMixin {
  late final _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300));
  late final _tween = Tween(begin: 0, end: pi).animate(_controller);
  late final List<dynamic> _contentPath, _keyPath, _firstContentPath, _childTypePath;
  late final IWidgetDragReorderModule? _widgetDragModule;
  // bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionThemeWidget(
      child: ExpansionTile(
        title: Row(
          children: [
            SizedBox(
              width: 300 - widget.indent * 20 - 20,
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
              withKey: _childType() == 'dict',
              withAddWithinKey: true,
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
            Text(
              '(${_childElementCount()} items)',
              // style: _expanded ? null : const TextStyle(color: Colors.white60)
            )
          ],
        ),
        onExpansionChanged: (expand) {
          _controller.isCompleted
              ? _controller.reverse()
              : _controller.forward();
          // setState(() => _expanded = expand);
        },
        leading: _leading(),
        trailing: const SizedBox(),
        children: _children(),
      ),
    );
  }

  _childType() {
    return context.read<EditCubit>().editViewModel.anyXML.getPath(_childTypePath);
  }

  _childElementCount() {
    return context.read<EditCubit>().editViewModel.anyXML.getPath(_contentPath).length;
  }

  _children() {
    final nextIndent = widget.indent + 1;
    List<Widget> children = TreeBuilder().buildWidgets(context, _contentPath, nextIndent, widget.update);
    if (_widgetDragModule != null) {
      _widgetDragModule!.addDragReorder(context, children);
    }
    return children;
  }

  _leading() {
    return SizedBox(
      width: 20.0,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.rotate(
          angle: _tween.value.toDouble(),
          child: const Icon(
            Icons.expand_more,
            size: 22.0,
          ),
        ),
      ),
    );
  }

  _init() {
    _contentPath = List.from(widget.path)..addAll(['content', 'content']);
    _keyPath = List.from(widget.path)..add('key');
    _widgetDragModule = globals.isMobile
        ? null
        : WidgetDragReorderModuleMouse(
            update: widget.update,
            path: _contentPath);
    _firstContentPath = List.from(widget.path)..add('content');
    _childTypePath = List.from(widget.path)..addAll(['content', 'type']);
  }
}
