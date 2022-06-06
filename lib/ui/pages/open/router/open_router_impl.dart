import 'package:anyplist/ui/pages/open/router/open_router_contract.dart';
import 'package:anyxml/anyxml.dart';
import 'package:flutter/material.dart';

class OpenRouter implements IOpenRouter {
  final Widget Function(AnyXML anyXML) onOpenSuccessConnect;

  OpenRouter(this.onOpenSuccessConnect);

  @override
  void onOpenSuccess(BuildContext context, AnyXML anyXML) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => onOpenSuccessConnect(anyXML)),
        (Route<dynamic> route) => false);
  }
}