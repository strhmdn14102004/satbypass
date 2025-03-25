import "package:base/base.dart";
import "package:dio/dio.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:sasat_toko/api/api_manager.dart";
import "package:sasat_toko/api/endpoint/bypass/bypass_response.dart";
import "package:sasat_toko/module/bypass/bypass_event.dart";
import "package:sasat_toko/module/bypass/bypass_state.dart";

class BypassBloc extends Bloc<BypassEvent, BypassState> {
  BypassBloc() : super(BypassInitial()) {
    on<LoadBypass>((event, emit) async {
      try {
        emit(BypassLoadLoading());

        Response response = await ApiManager.getBypass();

        if (response.statusCode == 200) {
          final List<dynamic> bypassdata = response.data; // Perbaikan di sini

          emit(
            BypassLoadSuccess(
              bypassList:
                  bypassdata.map((item) => BypassModel.fromJson(item)).toList(),
            ),
          );
        } else {
          emit(BypassLoadFailed(message: "Failed to load Bypass data"));
        }
      } catch (e) {
        ErrorOverlay(message: "unknown_error_please_try_again".tr());
        emit(BypassLoadFailed(message: "Failed to load Bypass data"));
      } finally {
        emit(BypassLoadFinished());
      }
    });
  }
}
