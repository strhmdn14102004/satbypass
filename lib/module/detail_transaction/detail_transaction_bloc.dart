// ignore_for_file: depend_on_referenced_packages
import "dart:async";

import "package:bloc/bloc.dart";
import "package:sasat_toko/api/api_manager.dart";
import "package:sasat_toko/api/endpoint/detail_transaction/detail_transaction_response.dart";
import "package:sasat_toko/module/detail_transaction/detail_transaction_event.dart";
import "package:sasat_toko/module/detail_transaction/detail_transaction_state.dart";

class TransactionDetailBloc
    extends Bloc<TransactionDetailEvent, TransactionDetailState> {
  TransactionDetailBloc() : super(TransactionDetailInitial()) {
    on<FetchTransactionDetail>(_onFetchTransactionDetail);
  }

  Future<void> _onFetchTransactionDetail(
    FetchTransactionDetail event,
    Emitter<TransactionDetailState> emit,
  ) async {
    emit(TransactionDetailLoading());
    try {
      final response =
          await ApiManager.getTransactionDetail(event.transactionId);

      if (response.statusCode == 200) {
        final transaction = DetailTransaction.fromJson(response.data);
        emit(TransactionDetailLoaded(transaction));
      } else {
        emit(
          TransactionDetailError(
            response.data["message"] ?? "Failed to load transaction details",
          ),
        );
      }
    } catch (e) {
      emit(TransactionDetailError(e.toString()));
    }
  }
}
