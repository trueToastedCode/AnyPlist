import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../states_management/edit/edit_cubit.dart';

class UpDownWidget extends StatelessWidget {
  final List<dynamic> path;
  final Function update;

  const UpDownWidget({Key? key, required this.path, required this.update}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 15,
          height: 15,
          child: TextButton(
            onPressed: () => _reorder(context, true),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(const CircleBorder()),
              backgroundColor: MaterialStateProperty.all(Colors.white24),
              minimumSize: MaterialStateProperty.all(Size.zero),
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
            child: const Center(
              child: Icon(Icons.keyboard_arrow_up, size: 14, color: Colors.black54),
            ),
          ),
        ),
        const SizedBox(width: 3),
        SizedBox(
          width: 15,
          height: 15,
          child: TextButton(
            onPressed: () => _reorder(context, false),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(const CircleBorder()),
              backgroundColor: MaterialStateProperty.all(Colors.white24),
              minimumSize: MaterialStateProperty.all(Size.zero),
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
            child: const Center(
              child: Icon(Icons.keyboard_arrow_down, size: 14, color: Colors.black54),
            ),
          ),
        ),
      ],
    );
  }

  _reorder(BuildContext context, bool up) {
    final start = this.path.last;
    if (start.runtimeType != int) {
      throw Exception('Unexpected path end');
    } else if ((up && start == 0) || (!up && start + 1 == _len(context))) {
      return;
    }
    final end = start + (up ? -1 : 1);
    final editCubit = context.read<EditCubit>();
    final path = List.from(this.path)..removeLast();
    editCubit.editViewModel.anyXML.reorder(path, start, end);
    editCubit.addUndo(
        '[${path.join(' → ')}] Reorder $start to $end',
          () {
            editCubit.editViewModel.anyXML.reorder(path, end, start);
            update();
          },
          () {
            editCubit.editViewModel.anyXML.reorder(path, start, end);
            update();
          });
    update();
  }

  _len (BuildContext context) {
    return context.read<EditCubit>().editViewModel.anyXML.getPath(List.from(path)..removeLast()).length;
  }
}
