import "package:equatable/equatable.dart";
import "package:sasat_toko/api/endpoint/create_transcation/create_transaction.dart";

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class CreateTransactionEvent extends TransactionEvent {
  final CreateTransaction transaction;

  const CreateTransactionEvent(this.transaction);

  @override
  List<Object> get props => [transaction];
}
