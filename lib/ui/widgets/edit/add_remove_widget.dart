import 'package:anyplist/states_management/edit/edit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddRemoveWidget extends StatelessWidget {
  final List<dynamic> path;
  final Function update;
  final bool withRemove, withKey, withAddWithinKey, withAddWithin;

  const AddRemoveWidget({Key? key, required this.path, required this.update, this.withRemove = true, this.withKey = false, this.withAddWithinKey = false, this.withAddWithin = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      width: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _children(context),
      ),
    );
  }

  _children(BuildContext context) {
    final widgets = <Widget>[
      SizedBox(
        width: 16.5,
        height: 16.5,
        child: TextButton(
          onPressed: () => _add(context),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(const CircleBorder()),
            backgroundColor: MaterialStateProperty.all(Colors.white24),
            minimumSize: MaterialStateProperty.all(Size.zero),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
          ),
          child: const Center(
            child: Icon(Icons.add, size: 14, color: Colors.black54),
          ),
        ),
      )
    ];
    if (withRemove) {
      widgets.addAll([
        const SizedBox(width: 3),
        SizedBox(
          width: 16.5,
          height: 16.5,
          child: TextButton(
            onPressed: () => _remove(context),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(const CircleBorder()),
              backgroundColor: MaterialStateProperty.all(Colors.white24),
              minimumSize: MaterialStateProperty.all(Size.zero),
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
            child: const Center(
              child: Icon(Icons.remove, size: 14, color: Colors.black54),
            ),
          ),
        ),
      ]);
    }
    return widgets;
  }

  _add(BuildContext context) {
    if (withAddWithinKey && withAddWithin) {
      throw Exception('Cant use withAddWithinKey as well as withAddWithin');
    }
    final path = withAddWithinKey
        ? (List.from(this.path)..addAll(['content', 'content']))
        : withAddWithin
            ? (List.from(this.path)..addAll(['content']))
            : this.path;
    final editCubit = context.read<EditCubit>();
    if (withAddWithinKey || withAddWithin) {
      path.add(editCubit.editViewModel.anyXML.getPath(path).length - 1);
    }
    final len = editCubit.editViewModel.anyXML.getPath(List.from(path)..removeLast()).length;
    final newPathEnd = List.from(path)..removeLast()..add(len);
    final newPath = List.from(path)..removeLast()..add(path.last + 1);
    final value = withKey
        ? {'type': 'key', 'args': null, 'key': '', 'content': {'type': 'string', 'args': null, 'content': ''}}
        : {'type': 'string', 'args': null, 'content': ''};
    editCubit.editViewModel.anyXML.setPath(newPathEnd, value);
    editCubit.editViewModel.anyXML.reorder(List.from(path)..removeLast(), newPathEnd.last, newPath.last);
    editCubit.addUndo(
        '[${newPath.join(' → ')}] Add element',
        () {
          editCubit.editViewModel.anyXML.setPath(newPath, null);
          update();
        },
        () {
          editCubit.editViewModel.anyXML.setPath(newPathEnd, value);
          editCubit.editViewModel.anyXML.reorder(List.from(path)..removeLast(), newPathEnd.last, newPath.last);
          update();
        });
    update();
  }

  _remove(BuildContext context) {
    final editCubit = context.read<EditCubit>();
    final value = context.read<EditCubit>().editViewModel.anyXML.getPath(path);
    final len = editCubit.editViewModel.anyXML.getPath(List.from(path)..removeLast()).length;
    final newPathEnd = List.from(path)..removeLast()..add(len);
    editCubit.editViewModel.anyXML.setPath(path, null);
    editCubit.addUndo(
        '[${path.join(' → ')}] Remove element',
        () {
          editCubit.editViewModel.anyXML.setPath(newPathEnd, value);
          editCubit.editViewModel.anyXML.reorder(List.from(path)..removeLast(), newPathEnd.last - 1, path.last);
          update();
        },
        () {
          editCubit.editViewModel.anyXML.setPath(path, null);
          update();
        });
    update();
  }
}
