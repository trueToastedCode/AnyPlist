import 'package:anyplist/viewmodels/base_view_model.dart';
import 'package:anyxml/anyxml.dart';

class EditViewModel extends BaseViewModel {
  AnyXML get anyXML => _anyXML;
  final AnyXML _anyXML;

  EditViewModel(this._anyXML);
}