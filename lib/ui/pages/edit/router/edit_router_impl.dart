import 'package:anyplist/ui/pages/edit/router/edit_router_contract.dart';
import 'package:flutter/material.dart';

class EditRouter implements IEditRouter {
  final Widget Function() onLeaveConnect;

  EditRouter(this.onLeaveConnect);

  @override
  void onLeave(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => onLeaveConnect()),
        (Route<dynamic> route) => false);
  }
}