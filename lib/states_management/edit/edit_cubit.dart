import 'package:anyplist/states_management/edit/edit_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../viewmodels/edit_view_model.dart';

class EditCubit extends Cubit<EditState> {
  EditViewModel get editViewModel => _editViewModel;
  final EditViewModel _editViewModel;
  List<Map<String, dynamic>> get undoList => _undoList;
  List<Map<String, dynamic>> get redoList => _redoList;
  final _undoList = <Map<String, dynamic>>[], _redoList = <Map<String, dynamic>>[];

  EditCubit(this._editViewModel) : super(EditInitialState());

  addUndo(String description, Function undo, Function redo) {
    _undoList.add({
      'description': description,
      'undo': undo,
      'redo': redo
    });
  }

  undo() {
    if (undoList.isEmpty) return;
    final element = _undoList.last;
    final description = element['description'];
    element['undo']();
    _redoList.add({
      'description': element['description'],
      'undo': element['undo'],
      'redo': element['redo'],
    });
    _undoList.removeLast();
    return description;
  }

  redo() {
    if (redoList.isEmpty) return;
    final element = _redoList.last;
    final description = element['description'];
    element['redo']();
    _undoList.add({
      'description': element['description'],
      'undo': element['undo'],
      'redo': element['redo'],
    });
    _redoList.removeLast();
    return description;
  }
}