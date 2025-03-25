// ignore_for_file: always_specify_types, empty_constructor_bodies

import "package:flutter_bloc/flutter_bloc.dart";
import "package:sasat_toko/module/history_transaction/history_transaction_event.dart";
import "package:sasat_toko/module/history_transaction/history_transaction_state.dart";


class HistoryTransactionBloc extends Bloc<HistoryTransactionEvent, HistoryTransactionState> {
  HistoryTransactionBloc() : super(HistoryTransactionInitial()) {}
}
