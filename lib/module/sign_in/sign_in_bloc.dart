import "dart:convert";

import "package:dio/dio.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:sasat_toko/api/api_manager.dart";
import "package:sasat_toko/api/endpoint/sign_in/sign_in_response.dart";
import "package:sasat_toko/module/sign_in/sign_in_event.dart";
import "package:sasat_toko/module/sign_in/sign_in_state.dart";
import "package:shared_preferences/shared_preferences.dart";

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitial()) {
    on<SignInSubmit>(_onSignInSubmit);
  }

  Future<void> _onSignInSubmit(
    SignInSubmit event,
    Emitter<SignInState> emit,
  ) async {
    emit(SignInSubmitLoading());

    try {
      final response =
          await ApiManager.signIn(signInRequest: event.signInRequest);

      if (response.statusCode == 200) {
        final signInResponse = SignInResponse.fromJson(response.data);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', signInResponse.token);

        Map<String, dynamic> userData = {
          "id": signInResponse.user.id,
          "username": signInResponse.user.username,
          "fullName": signInResponse.user.fullName,
          "address": signInResponse.user.address,
          "phoneNumber": signInResponse.user.phoneNumber,
        };

        await prefs.setString('user_data', jsonEncode(userData));

        print("Token disimpan: ${signInResponse.token}");
        print("User data disimpan: ${jsonEncode(userData)}");

        emit(SignInSubmitSuccess(data: signInResponse));
      } else {
        emit(
          SignInSubmitFailed(
            errorMessage: "Login gagal. Cek username dan password.",
          ),
        );
      }
    } catch (e) {
      if (e is DioException) {
        emit(
          SignInSubmitFailed(
            errorMessage: e.message ?? "Terjadi kesalahan saat login.",
          ),
        );
      } else {
        emit(
          SignInSubmitFailed(
            errorMessage: "Terjadi kesalahan yang tidak diketahui.",
          ),
        );
      }
    } finally {
      emit(SignInSubmitFinished());
    }
  }
}
