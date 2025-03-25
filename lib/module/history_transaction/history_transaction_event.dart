import "package:equatable/equatable.dart";

abstract class HistoryTransactionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchHistoryTransaction extends HistoryTransactionEvent {}
