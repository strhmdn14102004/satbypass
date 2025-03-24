// ignore_for_file: use_build_context_synchronously, always_specify_types

import "package:base/base.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:sasat_toko/helper/formats.dart";
import "package:sasat_toko/module/home/home_bloc.dart";
import "package:sasat_toko/module/home/home_state.dart";
import "package:smooth_corner/smooth_corner.dart";

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    refresh();
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
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          margin: EdgeInsets.only(
            bottom: Dimensions.size20,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.size20,
            vertical: Dimensions.size30,
          ),
          decoration: ShapeDecoration(
            shape: SmoothRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(Dimensions.size30),
                bottomRight: Radius.circular(Dimensions.size30),
              ),
              smoothness: 1,
            ),
            color: AppColors.inverseSurface(),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Formats.spell("Welcome"),
                          style: TextStyle(
                            color: AppColors.surface(),
                            fontSize: Dimensions.text16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(width: Dimensions.size20),
            ],
          ),
        ),
      ],
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
          width: (Dimensions.screenWidth - 70) / 4,
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
        spacing: Dimensions.size10,
        runSpacing: Dimensions.size10,
        children: [
          item(
            label: "IMEI".tr(),
            icon: Icons.phone_android_outlined,
            onTap: () async {
              await context.push("/imei-list");
            },
          ),
          item(
            label: "BYPASS".tr(),
            icon: Icons.security_rounded,
            onTap: () async {
              await context.push("/tickets");
            },
          ),
        ],
      ),
    );
  }
}
