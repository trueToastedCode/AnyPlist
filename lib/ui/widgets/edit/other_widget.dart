import 'package:anyxml/anyxml.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../states_management/edit/edit_cubit.dart';

class OtherWidget extends StatefulWidget {
  final List<dynamic> path;

  const OtherWidget({Key? key, required this.path}) : super(key: key);

  @override
  State<OtherWidget> createState() => _OtherWidgetState();
}

class _OtherWidgetState extends State<OtherWidget> {
  late final List<dynamic> _dataPath;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(_compiled())
          ),
        ],
      ),
    );
  }

  _data() {
    return context.read<EditCubit>().editViewModel.anyXML.getPath(_dataPath);
  }

  _compiled() {
    final tag = Tag.fromJson(_data());
    return tag.compile();
  }

  _init() {
    _dataPath = List.from(widget.path)..add('content');
  }
}
