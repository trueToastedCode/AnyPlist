import 'package:anyplist/ui/pages/edit/edit_page.dart';
import 'package:anyplist/ui/pages/edit/router/edit_router_impl.dart';
import 'package:anyplist/ui/pages/open/open_page.dart';
import 'package:anyplist/ui/pages/open/router/open_router_impl.dart';
import 'package:anyplist/viewmodels/edit_view_model.dart';
import 'package:anyxml/anyxml.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './ui/pages/edit/edit_page.dart';
import 'states_management/edit/edit_cubit.dart';

import 'states_management/open/open_cubit.dart';

class CompositionRoot {
  static configure() async {}

  static Widget start() {
    return composeOpenUi();
  }

  static Widget composeOpenUi() {
    final router = OpenRouter(composeEditUi);
    final openCubit = OpenCubit();
    return BlocProvider(
      create: (BuildContext context) => openCubit,
      child: OpenPage(router: router),
    );
  }

  static Widget composeEditUi(AnyXML anyXML) {
    final editViewModel = EditViewModel(anyXML);
    final editCubit = EditCubit(editViewModel);
    final router = EditRouter(composeOpenUi);
    return BlocProvider(
      create: (BuildContext context) => editCubit,
      child: EditPage(router: router)
    );
  }
}
