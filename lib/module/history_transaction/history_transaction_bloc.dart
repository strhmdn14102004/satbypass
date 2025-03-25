import "package:flutter_bloc/flutter_bloc.dart";
import "package:sasat_toko/api/api_manager.dart";
import "package:sasat_toko/api/endpoint/history_transaction/histori_transaction_response.dart";
import "package:sasat_toko/module/history_transaction/history_transaction_event.dart";
import "package:sasat_toko/module/history_transaction/history_transaction_state.dart";

class HistoryTransactionBloc
    extends Bloc<HistoryTransactionEvent, HistoryTransactionState> {
  HistoryTransactionBloc() : super(HistoryTransactionInitial()) {
    on<FetchHistoryTransaction>((event, emit) async {
      emit(HistoryTransactionLoading());
      try {
        final response = await ApiManager.getTransactionHistory();
        if (response.statusCode == 200) {
          final data = HistorytransactionResponse.fromJson(response.data);
          emit(HistoryTransactionLoaded(transactions: data.data));
        } else {
          emit(HistoryTransactionError("Gagal mengambil data transaksi"));
        }
      } catch (e) {
        emit(HistoryTransactionError("Terjadi kesalahan: $e"));
      }
    });
  }
}
