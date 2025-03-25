import 'package:equatable/equatable.dart';

abstract class ImeiEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadImei extends ImeiEvent {}
