import "package:equatable/equatable.dart";

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionSuccess extends TransactionState {
  final String message;
  final String paymentUrl;

  const TransactionSuccess(this.message, this.paymentUrl);

  @override
  List<Object> get props => [message, paymentUrl];
}

class TransactionFailure extends TransactionState {
  final String error;

  const TransactionFailure(this.error);

  @override
  List<Object> get props => [error];
}
