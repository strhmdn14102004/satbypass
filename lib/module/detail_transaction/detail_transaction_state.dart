

import "package:equatable/equatable.dart";
import "package:sasat_toko/api/endpoint/detail_transaction/detail_transaction_response.dart";

abstract class TransactionDetailState extends Equatable {
  const TransactionDetailState();

  @override
  List<Object> get props => [];
}

class TransactionDetailInitial extends TransactionDetailState {}

class TransactionDetailLoading extends TransactionDetailState {}

class TransactionDetailLoaded extends TransactionDetailState {
  final DetailTransaction transaction;

  const TransactionDetailLoaded(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class TransactionDetailError extends TransactionDetailState {
  final String message;

  const TransactionDetailError(this.message);

  @override
  List<Object> get props => [message];
}