import "dart:convert";

import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:sasat_toko/api/api_manager.dart";
import "package:sasat_toko/api/endpoint/sign_in/sign_in_response.dart";
import "package:sasat_toko/helper/firebase.dart";
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
        await _saveUserSession(signInResponse);
        await _handleSuccessfulLogin();
        emit(SignInSubmitSuccess(data: signInResponse));
      } else {
        emit(
          SignInSubmitFailed(
            errorMessage: "Login failed. Please check your credentials.",
          ),
        );
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data["message"] ?? "Login failed. Please try again.";
      emit(SignInSubmitFailed(errorMessage: errorMessage));
    } catch (e) {
      emit(SignInSubmitFailed(errorMessage: "An unexpected error occurred."));
    } finally {
      emit(SignInSubmitFinished());
    }
  }

  Future<void> _saveUserSession(SignInResponse response) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("auth_token", response.token);

    final userData = {
      "id": response.user.id,
      "username": response.user.username,
      "fullName": response.user.fullName,
      "address": response.user.address,
      "phoneNumber": response.user.phoneNumber,
    };

    await prefs.setString("user_data", jsonEncode(userData));
  }

  Future<void> _handleSuccessfulLogin() async {
    try {
      // Update FCM token after successful login
      final success = await FirebaseNotification.updateFcmToken();
      if (kDebugMode) {
        print(
          success
              ? "✅ FCM token updated successfully"
              : "⚠️ Failed to update FCM token",
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error updating FCM token: $e");
      }
    }
  }
}
