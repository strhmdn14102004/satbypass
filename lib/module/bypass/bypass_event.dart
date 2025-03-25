import 'package:equatable/equatable.dart';

abstract class BypassEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadBypass extends BypassEvent {}
