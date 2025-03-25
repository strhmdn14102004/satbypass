// ignore_for_file: always_specify_types, use_build_context_synchronously

import "dart:convert";

import "package:base/base.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:sasat_toko/helper/formats.dart";
import "package:sasat_toko/module/history_transaction/history_transaction_bloc.dart";
import "package:sasat_toko/module/history_transaction/history_transaction_state.dart";
import "package:shared_preferences/shared_preferences.dart";

class HistoryTransactionPage extends StatefulWidget {
  const HistoryTransactionPage({
    super.key,
  });

  @override
  HistoryTransactionPageState createState() => HistoryTransactionPageState();
}

class HistoryTransactionPageState extends State<HistoryTransactionPage>
    with WidgetsBindingObserver {
  Map<String, dynamic>? user;
  @override
  void initState() {
    super.initState();
    loadUserData();
    WidgetsBinding.instance.addObserver(this);
  }

  void loadUserData() async {
    user = await getUserData();
    setState(() {});
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString("user_data");

    if (userJson != null) {
      return jsonDecode(userJson);
    }

    return {"fullName": "User"};
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HistoryTransactionBloc, HistoryTransactionState>(
      listener: (context, state) async {},
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: AppColors.inverseSurface(),
          statusBarIconBrightness: AppColors.brightness(),
        ),
        child: Scaffold(
          backgroundColor: AppColors.onPrimaryContainer(),
          body: SafeArea(
            child: Column(
              children: [
                header(),
                body(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();

    setState(() {});
  }

  Widget header() {
    return user == null
        ? BaseWidgets.shimmer()
        : Padding(
            padding: EdgeInsets.all(Dimensions.size20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Formats.spell("wellcome".tr()),
                                style: TextStyle(
                                  color: AppColors.surface(),
                                  fontSize: Dimensions.text16,
                                ),
                              ),
                              Text(
                                Formats.spell(
                                  user!["fullName"].toString().toUpperCase(),
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.surface(),
                                  fontSize: Dimensions.text16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.network(
                          Formats.spell(user!["fullName"]),
                          width: Dimensions.size70,
                          height: Dimensions.size70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: Dimensions.size50,
                            height: Dimensions.size50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.size50),
                              color: AppColors.secondaryContainer(),
                              border: Border.all(
                                color: AppColors.onPrimaryContainer(),
                              ),
                            ),
                            child: Text(
                              Formats.initials(
                                Formats.spell(user!["fullName"]),
                              ),
                              style: TextStyle(
                                fontSize: Dimensions.text20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onPrimaryContainer(),
                              ),
                            ),
                          ),
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                            return Container(
                              width: Dimensions.size50,
                              height: Dimensions.size50,
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer(),
                                borderRadius:
                                    BorderRadius.circular(Dimensions.size50),
                                border: Border.all(
                                  color: AppColors.onPrimaryContainer(),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(Dimensions.size50),
                                child: child,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.size20),
                  ],
                ),
              ],
            ),
          );
  }

  Widget body() {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          setting(),
          SizedBox(
            height: Dimensions.size20,
          ),
        ],
      ),
    );
  }

  Widget setting() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.size20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "buy_history".tr(),
            style: TextStyle(
              color: AppColors.surface(),
              fontWeight: FontWeight.bold,
              fontSize: Dimensions.text16,
            ),
          ),
          SizedBox(
            height: Dimensions.size10,
          ),
        ],
      ),
    );
  }
}
