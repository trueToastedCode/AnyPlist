import 'dart:math';
import 'dart:io' show Platform;

import 'package:anyplist/ui/widgets/edit/expansion_theme_widget.dart';
import 'package:anyplist/ui/widgets/edit/tree_builder.dart';
import 'package:anyplist/ui/widgets/edit/type_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/widget_drag_reorder_module/widget_drag_reorder_module_mouse.dart';
import '../../../models/widget_drag_reorder_module/widget_drag_reorder_module_contract.dart';
import '../../../states_management/edit/edit_cubit.dart';
import 'add_remove_widget.dart';
import '../../../globals.dart' as globals;
import 'up_down_widget.dart';

class ArrayPlistDictWidget extends StatefulWidget {
  final List<dynamic> path;
  final int indent;
  final Function update;

  const ArrayPlistDictWidget({Key? key, required this.path, required this.indent, required this.update}) : super(key: key);

  @override
  State<ArrayPlistDictWidget> createState() => _ArrayPlistDictWidgetState();
}

class _ArrayPlistDictWidgetState extends State<ArrayPlistDictWidget> with TickerProviderStateMixin {
  late final _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300));
  late final _tween = Tween(begin: 0, end: pi).animate(_controller);
  late final List<dynamic> _contentPath, _typePath;
  late final _treeBuilder = TreeBuilder();
  late final IWidgetDragReorderModule? _widgetDragModule;
  // bool _expanded = false;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionThemeWidget(
      child: ExpansionTile(
        title: Row(
          children: [
            SizedBox(
              width: 300 - widget.indent * 20 - 20,
              child: Text(_type() == 'plist' ? 'Root' : 'Item ${widget.path.last}'),
            ),
            _addRemoveWidget(),
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
            Text(
              '(${_childElementCount()} items)',
              // style: _expanded ? null : const TextStyle(color: Colors.white60)
            ),
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

  _addRemoveWidget() {
    final type = _type();
    return AddRemoveWidget(
      path: widget.path,
      update: type == 'plist' ? () => setState(() {}) : widget.update,
      withRemove: type != 'plist',
      withKey: type == 'dict',
      withAddWithin: true,
    );
  }

  _childElementCount() {
    return context.read<EditCubit>().editViewModel.anyXML.getPath(_contentPath).length;
  }

  _type() {
    return context.read<EditCubit>().editViewModel.anyXML.getPath(_typePath);
  }

  _children() {
    final nextIndent = widget.indent + 1;
    List<Widget> children = _treeBuilder.buildWidgets(context, _contentPath, nextIndent, widget.update);
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
    _contentPath = List.from(widget.path)..add('content');
    _typePath = List.from(widget.path)..add('type');
    _widgetDragModule = globals.isMobile
        ? null
        : WidgetDragReorderModuleMouse(
            update: widget.update,
            path: _contentPath);
  }
}
