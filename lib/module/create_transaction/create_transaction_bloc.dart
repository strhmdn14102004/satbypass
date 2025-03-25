import "package:base/base.dart";
import "package:bloc/bloc.dart";
import "package:dio/dio.dart";
import "package:sasat_toko/api/api_manager.dart";
import "package:sasat_toko/constant/api_url.dart";
import "package:sasat_toko/module/create_transaction/create_transaction_event.dart";
import "package:sasat_toko/module/create_transaction/create_transaction_state.dart";
import "package:shared_preferences/shared_preferences.dart";

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial()) {
    on<CreateTransactionEvent>(_onCreateTransaction);
  }

  Future<void> _onCreateTransaction(
    CreateTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());

    try {
      Dio dio = await ApiManager.getDio();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      if (token == null || token.isEmpty) {
        emit(TransactionFailure("Token tidak ditemukan. Harap login kembali."));
        return;
      }

      final response = await dio.post(
        ApiUrl.HISTORY.path,
        data: event.transaction.toJson(),
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

    if (response.statusCode == 200 || response.statusCode == 201) {
  final paymentUrl = response.data["paymentUrl"] ?? "";
  
  emit(TransactionSuccess("Transaksi berhasil dibuat.", paymentUrl));

  BaseOverlays.success(
    message: "Transaksi Berhasil dilakukan, cek riwayat transaksi",
  );

      } else {
        emit(TransactionFailure(
          "Gagal membuat transaksi: ${response.data['message'] ?? 'Kesalahan tidak diketahui.'}",
        ),);
        BaseOverlays.error(message: "{$response");
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?["message"] ?? e.message;
      emit(TransactionFailure("Kesalahan jaringan: $errorMessage"));
    } catch (e) {
      emit(TransactionFailure("Terjadi kesalahan: ${e.toString()}"));
    }
  }
}
