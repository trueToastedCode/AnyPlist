import 'package:anyplist/models/widget_drag_reorder_module/widget_drag_reorder_module_contract.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../states_management/edit/edit_cubit.dart';
import '../../ui/widgets/drag_reorder/reorder_feedback_widget.dart';
import '../../ui/widgets/drag_reorder/reorder_separator_widget.dart';

class WidgetDragReorderModuleMouse implements IWidgetDragReorderModule {
  final List<dynamic> path;
  final Function _update;

  WidgetDragReorderModuleMouse({required Function update, required this.path}) : _update = update;

  int _dragStart = -1, _dragEnd = -1;

  _reorder(BuildContext context) async {
    if (_isValidDrag()) {
      final editCubit = context.read<EditCubit>();
      int start = _dragStart, end = _dragEnd;
      editCubit.editViewModel.anyXML.reorder(path, start, end);
      editCubit.addUndo(
          '[${path.join(' → ')}] Reorder $start to $end',
            () {
              editCubit.editViewModel.anyXML.reorder(path, end, start);
              _update();
            },
            () {
              editCubit.editViewModel.anyXML.reorder(path, start, end);
              _update();
            });
    }
    _resetDrag();
  }

  @override
  addDragReorder(BuildContext context, List<Widget> widgets) {
    for (int i=0; i<widgets.length; i++) {
      widgets[i] = MouseRegion(
        onEnter: (details) {
          if (_dragStart != -1 && _dragEnd != i) {
            // dragging from start widget where last target end is not current widget
            if (_dragStart == i) {
              //  current drag target it start widget
              if (_dragEnd != -1) {
                // remove last target end since start widget is selected
                _dragEnd = -1;
                _update();
              }
            } else {
              // new drag target that is not start
              _dragEnd = i;
              _update();
            }
          }
        },
        child: Draggable(
          feedback: const ReorderFeedbackWidget(),
          onDragStarted: () => _dragStart = i,
          onDraggableCanceled: (velocity, offset) => _reorder(context),
          child: widgets[i],
        ),
      );
    }
    _addDragSeparator(widgets);
  }

  _addDragSeparator(List<Widget> widgets) {
    if (_isValidDrag()) {
      // there is some dragging
      if (_dragEnd > _dragStart) {
        widgets.insert(_dragEnd + 1, const ReorderSeparatorWidget());
      } else {
        widgets.insert(_dragEnd, const ReorderSeparatorWidget());
      }
    }
  }

  _isValidDrag() {
    return _dragEnd != -1 && _dragStart != -1;
  }

  _isDragResetNeeded() {
    return _dragEnd != -1 || _dragStart != -1;
  }

  _resetDrag() {
    if (_isDragResetNeeded()) {
      // reset needed
      _dragStart = -1;
      _dragEnd = -1;
      _update();
    }
  }
}