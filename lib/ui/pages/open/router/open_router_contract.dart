import 'package:anyxml/anyxml.dart';
import 'package:flutter/material.dart';

abstract class IOpenRouter {
  void onOpenSuccess(BuildContext context, AnyXML anyXML);
}