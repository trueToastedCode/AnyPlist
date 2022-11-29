import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:anyplist/states_management/open/open_state.dart';
import 'package:anyxml/anyxml.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart' show rootBundle;


class OpenCubit extends Cubit<OpenState> {

  OpenCubit() : super(OpenInitialState());

  open() async {
    try {
      final filePath = await FilePicker.platform.pickFiles(allowMultiple: false);
      if (filePath == null) return;
      String data;
      if (kIsWeb) {
        data = String.fromCharCodes(filePath.files.single.bytes!);
      } else {
        emit(OpenLoadingState());
        data = File(filePath.files.single.path!).readAsStringSync();
      }
      if (data.isEmpty) {
        emit(OpenFailureState('File is empty'));
      }
      AnyXML anyXML;
      try {
        anyXML = XMLParser().parseXML(data);
      } on Exception catch(e) {
        emit(OpenFailureState(e.toString()));
        return;
      }
      emit(OpenSuccessState(anyXML));
    } on Exception catch(e) {
      emit(OpenFailureState(e.toString()));
    }
  }

  newplist() async {
    String data;
    try {
      data = await rootBundle.loadString('assets/sample.plist');
    } on Exception catch(e) {
      emit(OpenFailureState(e.toString()));
      return;
    }
    AnyXML anyXML;
    try {
      anyXML = XMLParser().parseXML(data);
    } on Exception catch(e) {
      emit(OpenFailureState(e.toString()));
      return;
    }
    emit(OpenSuccessState(anyXML));
  }

  reset() {
    emit(OpenInitialState());
  }
}