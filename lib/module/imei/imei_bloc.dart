import "package:base/src/base_overlays.dart";
import "package:dio/dio.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:sasat_toko/api/api_manager.dart";
import "package:sasat_toko/api/endpoint/imei/imei.dart";
import "package:sasat_toko/module/imei/imei_event.dart";
import "package:sasat_toko/module/imei/imei_state.dart";

class ImeiBloc extends Bloc<ImeiEvent, ImeiState> {
  ImeiBloc() : super(ImeiInitial()) {
    on<LoadImei>((event, emit) async {
      try {
        emit(ImeiLoadLoading());

        Response response = await ApiManager.getImei();

        if (response.statusCode == 200) {
          final List<dynamic> imeiData =
              (response.data as Map<String, dynamic>)["data"];

          emit(
            ImeiLoadSuccess(
              imeiList:
                  imeiData.map((item) => ImeiModel.fromJson(item)).toList(),
            ),
          );
        } else {
          emit(ImeiLoadFailed(message: "Failed to load IMEI data"));
        }
      } catch (e) {
        ErrorOverlay(message: "unknown_error_please_try_again".tr());
        emit(ImeiLoadFailed(message: "Failed to load IMEI data"));
      } finally {
        emit(ImeiLoadFinished());
      }
    });
  }
}
