import "dart:convert";
import "dart:typed_data";

import "package:base/base.dart";
import "package:dio/dio.dart";
import "package:sasat_toko/api/endpoint/sign_in/sign_in_request.dart";
import "package:sasat_toko/api/endpoint/sign_up/sign_up_request.dart";
import "package:sasat_toko/api/interceptor/authorization_interceptor.dart";
import "package:sasat_toko/constant/api_url.dart";
import "package:sasat_toko/helper/formats.dart";
import "package:shared_preferences/shared_preferences.dart";

class ApiManager {
  static bool PRIMARY = true;

  static Future<Dio> getDio() async {
    Dio dio = Dio(
      BaseOptions(
        baseUrl: PRIMARY ? MAIN_BASE : SECONDARY_BASE,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        contentType: Headers.jsonContentType,
        receiveDataWhenStatusError: false,
        validateStatus: (status) => status != null,
        responseDecoder: (responseBytes, options, responseBody) {
          String value = utf8.decode(responseBytes, allowMalformed: true);

          if (responseBody.statusCode >= 300) {
            try {
              return jsonDecode(value);
            } catch (ex) {
              return value;
            }
          } else {
            return value;
          }
        },
      ),
    );

    dio.interceptors.add(BaseEncodingInterceptor());
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        request: true,
        requestHeader: true,
        responseHeader: true,
      ),
    );
    dio.interceptors.add(AuthorizationInterceptor());

    return dio;
  }

  static Future<Uint8List> download({
    required String url,
  }) async {
    Response response = await Dio().get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );

    return response.data;
  }

  static Future<Response> signIn({
    required SignInRequest signInRequest,
  }) async {
    Dio dio = await getDio();

    Response response = await dio.post(
      ApiUrl.SIGN_IN.path,
      data: Formats.convert(signInRequest.toJson()),
    );

    return response;
  }

  static Future<Response> signUp({
    required SignUpRequest signUpRequest,
  }) async {
    Dio dio = await getDio();

    Response response = await dio.post(
      ApiUrl.SIGN_UP.path,
      data: signUpRequest.toJson(),
    );

    return response;
  }

  static Future<Response> account() async {
    Dio dio = await getDio();

    Response response = await dio.get(
      ApiUrl.ACCOUNT.path,
    );

    return response;
  }

  static Future<Response> getImei() async {
    Dio dio = await getDio();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");
    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan. Harap login kembali.");
    }
    Response response = await dio.get(
      ApiUrl.IMEI.path,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return response;
  }

  static Future<Response> getBypass() async {
    Dio dio = await getDio();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");
    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan. Harap login kembali.");
    }
    Response response = await dio.get(
      ApiUrl.BYPASS.path,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return response;
  }

  static Future<Response> getTransactionHistory() async {
    Dio dio = await getDio();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");
    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan. Harap login kembali.");
    }
    Response response = await dio.get(
      ApiUrl.HISTORY.path,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return response;
  }

  static Future<Response> updateFcmToken(String fcmToken) async {
    final dio = await getDio();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");

    if (token == null) {
      throw Exception("Authentication token not found");
    }

    try {
      final response = await dio.post(
        ApiUrl.FCM.path,
        data: jsonEncode({"fcm_token": fcmToken}),
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? "Failed to update FCM token");
      }
      rethrow;
    }
  }
}
