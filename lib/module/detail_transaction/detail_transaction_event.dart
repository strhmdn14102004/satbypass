
import "package:equatable/equatable.dart";

abstract class TransactionDetailEvent extends Equatable {
  const TransactionDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTransactionDetail extends TransactionDetailEvent {
  final String transactionId;

  const FetchTransactionDetail(this.transactionId);

  @override
  List<Object> get props => [transactionId];
}
