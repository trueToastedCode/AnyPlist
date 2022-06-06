import 'package:equatable/equatable.dart';

abstract class EditState extends Equatable {}

class EditInitialState extends EditState {
  @override
  List<Object> get props => [];
}
