import 'package:equatable/equatable.dart';
import "package:sasat_toko/api/endpoint/bypass/bypass_response.dart";

abstract class BypassState extends Equatable {
  @override
  List<Object> get props => [];
}

class BypassInitial extends BypassState {}

class BypassLoadLoading extends BypassState {}

class BypassLoadSuccess extends BypassState {
  final List<BypassModel> BypassList;

  BypassLoadSuccess({required this.BypassList});

  @override
  List<Object> get props => [BypassList];
}

class BypassLoadFailed extends BypassState {
  final String message;

  BypassLoadFailed({required this.message});

  @override
  List<Object> get props => [message];
}

class BypassLoadFinished extends BypassState {}
