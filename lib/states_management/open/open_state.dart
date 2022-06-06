import 'package:anyxml/anyxml.dart';
import 'package:equatable/equatable.dart';

abstract class OpenState extends Equatable {}

class OpenInitialState extends OpenState {
  @override
  List<Object> get props => [];
}

class OpenLoadingState extends OpenState {
  @override
  List<Object> get props => [];
}

class OpenFailureState extends OpenState {
  final String message;

  OpenFailureState(this.message);

  @override
  List<Object> get props => [message];
}

class OpenSuccessState extends OpenState {
  final AnyXML anyXML;

  OpenSuccessState(this.anyXML);

  @override
  List<Object> get props => [anyXML];
}