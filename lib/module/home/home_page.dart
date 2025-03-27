import "dart:convert";

import "package:base/base.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:sasat_toko/helper/formats.dart";
import "package:sasat_toko/module/home/home_bloc.dart";
import "package:sasat_toko/module/home/home_state.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:smooth_corner/smooth_corner.dart";

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with WidgetsBindingObserver {
  Map<String, dynamic>? user;
  @override
  void initState() {
    super.initState();
    loadUserData();
    WidgetsBinding.instance.addObserver(this);

    refresh();
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
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) async {},
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: AppColors.inverseSurface(),
          statusBarIconBrightness: AppColors.brightness(),
        ),
        child: Scaffold(
          backgroundColor: AppColors.onPrimaryContainer(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                  bottom: Dimensions.size20,
                ),
                child: Column(
                  children: [
                    header(),
                    menu(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  void refresh() {}

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

  Widget menu() {
    Widget item({
      required String label,
      required IconData icon,
      required GestureTapCallback onTap,
    }) {
      return InkWell(
        onTap: onTap,
        customBorder: SmoothRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.size15),
          smoothness: 1,
        ),
        child: Ink(
          width: (Dimensions.screenWidth - 70) / 3,
          height: Dimensions.size100,
          decoration: ShapeDecoration(
            shape: SmoothRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.size15),
              smoothness: 1,
              side: BorderSide(
                color: AppColors.outline(),
              ),
            ),
            color: AppColors.surfaceContainerLowest(),
          ),
          padding: EdgeInsets.symmetric(
            vertical: Dimensions.size10,
            horizontal: Dimensions.size5,
          ),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: Dimensions.size35,
                  color: AppColors.onSurface(),
                ),
                SizedBox(height: Dimensions.size5),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.onSurface(),
                    fontSize: Dimensions.text11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.size20,
      ),
      child: Wrap(
        direction: Axis.horizontal,
        spacing: Dimensions.size15,
        runSpacing: Dimensions.size15,
        children: [
          item(
            label: "UNBLOCK_IMEI".tr(),
            icon: Icons.phone_android_outlined,
            onTap: () async {
              await context.push("/imei-list");
            },
          ),
          item(
            label: "BYPASS_A12".tr(),
            icon: Icons.security_rounded,
            onTap: () async {
              await context.push("/bypass-list");
            },
          ),
          item(
            label: "REMOVE_ICLOUD".tr(),
            icon: Icons.apple_rounded,
            onTap: () async {
              await context.push("/remove-icloud");
            },
          ),
          item(
            label: "MDM_BYPASS".tr(),
            icon: Icons.manage_accounts_rounded,
            onTap: () async {
              await context.push("/bypass-mdm");
            },
          ),
          item(
            label: "BYPASS_A11".tr(),
            icon: Icons.phone_iphone_rounded,
            onTap: () async {
              await context.push("/bypass-a11");
            },
          ),
          item(
            label: "FMI_OFF_OPEN_MENU".tr(),
            icon: Icons.emoji_flags_outlined,
            onTap: () async {
              await context.push("/fmi-off-openmenu");
            },
          ),
          item(
            label: "MACBOOK_BYPASS".tr(),
            icon: Icons.laptop_mac_rounded,
            onTap: () async {
              await context.push("/macbook-bypass");
            },
          ),
          item(
            label: "UNLOCK_APPLE_WATCH".tr(),
            icon: Icons.watch_rounded,
            onTap: () async {
              await context.push("/bypass-apple-watch");
            },
          ),
        ],
      ),
    );
  }
}
