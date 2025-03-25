import "package:equatable/equatable.dart";
import "package:sasat_toko/api/endpoint/imei/imei.dart";

abstract class ImeiState extends Equatable {
  @override
  List<Object> get props => [];
}

class ImeiInitial extends ImeiState {}

class ImeiLoadLoading extends ImeiState {}

class ImeiLoadSuccess extends ImeiState {
  final List<ImeiModel> imeiList;

  ImeiLoadSuccess({required this.imeiList});

  @override
  List<Object> get props => [imeiList];
}

class ImeiLoadFailed extends ImeiState {
  final String message;

  ImeiLoadFailed({required this.message});

  @override
  List<Object> get props => [message];
}

class ImeiLoadFinished extends ImeiState {}
