// ignore_for_file: always_specify_types

import "package:base/base.dart";
import "package:dio/dio.dart";
import "package:sasat_toko/api/api_manager.dart";
import "package:sasat_toko/constant/preference_key.dart";
import "package:sasat_toko/helper/preferences.dart";

class AuthorizationInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (Preferences.contain(PreferenceKey.SESSION_ID)) {
      options.headers["Authorization"] = "Bearer ${Preferences.getString(PreferenceKey.SESSION_ID)}";
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode != null) {
      if (response.statusCode! >= 300) {
        ApiManager.PRIMARY = !ApiManager.PRIMARY;

        if (response.data is String) {
          BaseOverlays.error(message: response.data);
        } else if (response.data is Map<String, dynamic>) {
          BaseOverlays.error(message: response.data["errorMessage"]);
        }

        handler.resolve(Response(requestOptions: response.requestOptions, statusCode: 218));

        return;
      }
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    ApiManager.PRIMARY = !ApiManager.PRIMARY;

    return handler.next(err);
  }
}
