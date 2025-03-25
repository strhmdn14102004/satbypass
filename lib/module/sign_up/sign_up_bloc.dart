// ignore_for_file: depend_on_referenced_packages

import "package:bloc/bloc.dart";
import "package:sasat_toko/api/api_manager.dart";
import "package:sasat_toko/api/endpoint/sign_up/sign_up_request.dart";
import "package:sasat_toko/module/sign_up/sign_up_event.dart";
import "package:sasat_toko/module/sign_up/sign_up_state.dart";

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpSubmit>((event, emit) async {
      emit(SignUpSubmitLoading());

      try {
        final response = await ApiManager.signUp(
          signUpRequest: SignUpRequest(
            username: event.username,
            password: event.password,
            fullName: event.fullName,
            address: event.address,
            phoneNumber: event.phoneNumber,
          ),
        );

        if (response.statusCode == 201) {
          emit(SignUpSubmitSuccess(message: response.data["message"]));
        } else {
          emit(SignUpSubmitError(error: "Terjadi kesalahan saat mendaftar"));
        }
      } catch (e) {
        emit(SignUpSubmitError(error: e.toString()));
      }
    });
  }
}
