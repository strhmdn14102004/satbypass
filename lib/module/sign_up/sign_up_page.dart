import "package:base/base.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:sasat_toko/module/sign_up/sign_up_bloc.dart";
import "package:sasat_toko/module/sign_up/sign_up_event.dart";
import "package:sasat_toko/module/sign_up/sign_up_state.dart";

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController tecUsername = TextEditingController();
  final TextEditingController tecPassword = TextEditingController();
  final TextEditingController tecFullname = TextEditingController();
  final TextEditingController tecAddress = TextEditingController();
  final TextEditingController tecPhoneNumber = TextEditingController();

  bool obscurePassword = true;
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("sign_up".tr()),
      ),
      body: BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSubmitSuccess) {
            BaseOverlays.success(message: state.message);
            // Future.delayed(Duration(seconds: 1), () {
            //   Navigator.pop(context); // Kembali setelah sukses
            // });
          } else if (state is SignUpSubmitError) {
            BaseOverlays.error(message: state.error);
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Dimensions.size20),
          child: Form(
            key: formState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/image/logo.png",
                  width: 200,
                  height: 150,
                ),
                SizedBox(height: Dimensions.size50),
                BaseWidgets.text(
                  mandatory: true,
                  readonly: false,
                  controller: tecUsername,
                  label: "username".tr(),
                  prefixIcon: const Icon(Icons.alternate_email),
                ),
                const SizedBox(height: 15),
                BaseWidgets.text(
                  mandatory: true,
                  readonly: false,
                  controller: tecPassword,
                  label: "password".tr(),
                  obscureText: obscurePassword,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 15),
                BaseWidgets.text(
                  mandatory: true,
                  readonly: false,
                  controller: tecFullname,
                  label: "full_name".tr(),
                  prefixIcon: const Icon(Icons.person),
                ),
                const SizedBox(height: 15),
                BaseWidgets.text(
                  mandatory: true,
                  readonly: false,
                  controller: tecAddress,
                  label: "address".tr(),
                  prefixIcon: const Icon(Icons.home),
                ),
                const SizedBox(height: 15),
                BaseWidgets.text(
                  mandatory: true,
                  readonly: false,
                  controller: tecPhoneNumber,
                  label: "phone_number".tr(),
                  prefixIcon: const Icon(Icons.phone),
                ),
                const SizedBox(height: 20),
                BlocBuilder<SignUpBloc, SignUpState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: state is SignUpSubmitLoading
                            ? null
                            : () {
                                if (formState.currentState!.validate()) {
                                  context.read<SignUpBloc>().add(
                                        SignUpSubmit(
                                          username: tecUsername.text,
                                          password: tecPassword.text,
                                          fullName: tecFullname.text,
                                          address: tecAddress.text,
                                          phoneNumber: tecPhoneNumber.text,
                                        ),
                                      );
                                }
                              },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.tertiary(),
                          foregroundColor: AppColors.onTertiary(),
                        ),
                        child: state is SignUpSubmitLoading
                            ? const CircularProgressIndicator()
                            : Text("sign_up".tr()),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
