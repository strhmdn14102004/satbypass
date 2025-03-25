// ignore_for_file: use_build_context_synchronously, always_specify_types

import "package:base/base.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:sasat_toko/module/root/root_bloc.dart";
import "package:sasat_toko/module/root/root_state.dart";
import "package:smooth_corner/smooth_corner.dart";

class RootPage extends StatefulWidget {
  final StatefulNavigationShell statefulNavigationShell;

  const RootPage({
    required this.statefulNavigationShell,
    super.key,
  });

  @override
  RootPageState createState() => RootPageState();
}

class RootPageState extends State<RootPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RootBloc, RootState>(
      listener: (context, state) async {},
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: AppColors.surfaceContainerLowest(),
          systemNavigationBarIconBrightness: AppColors.brightnessInverse(),
        ),
        child: Scaffold(
          body: widget.statefulNavigationShell,
          bottomNavigationBar: bottomNavigationBar(),
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

  Widget bottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.outline(),
          ),
        ),
      ),
      child: NavigationBar(
        selectedIndex: widget.statefulNavigationShell.currentIndex,
        onDestinationSelected: (value) {
          widget.statefulNavigationShell.goBranch(value);
        },
        backgroundColor: AppColors.surfaceContainerLowest(),
        indicatorColor: AppColors.primaryContainer(),
        indicatorShape: SmoothRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.size10),
          smoothness: 1,
          side: BorderSide(color: AppColors.onPrimaryContainer()),
        ),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        height: Dimensions.size70,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(
              Icons.home,
              color: AppColors.onPrimaryContainer(),
            ),
            label: "home".tr(),
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(
              Icons.history_rounded,
              color: AppColors.onPrimaryContainer(),
            ),
            label: "history_transaction".tr(),
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            selectedIcon: Icon(
              Icons.account_circle,
              color: AppColors.onPrimaryContainer(),
            ),
            label: "account".tr(),
          ),
        ],
      ),
    );
  }
}
