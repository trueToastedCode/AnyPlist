import 'package:flutter/cupertino.dart';

abstract class IWidgetDragReorderModule {
  addDragReorder(BuildContext context, List<Widget> widgets);
}