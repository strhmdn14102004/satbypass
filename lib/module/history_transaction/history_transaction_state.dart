  import "package:equatable/equatable.dart";
  import "package:sasat_toko/api/endpoint/history_transaction/histori_transaction_response.dart";

  abstract class HistoryTransactionState extends Equatable {
    @override
    List<Object> get props => [];
  }

  class HistoryTransactionInitial extends HistoryTransactionState {}

  class HistoryTransactionLoading extends HistoryTransactionState {}

  class HistoryTransactionLoaded extends HistoryTransactionState {
    final List<HistoryTransactionItem> transactions;

    HistoryTransactionLoaded({required this.transactions});

    @override
    List<Object> get props => [transactions];
  }

  class HistoryTransactionError extends HistoryTransactionState {
    final String message;

    HistoryTransactionError(this.message);

    @override
    List<Object> get props => [message];
  }
