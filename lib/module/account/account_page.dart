// ignore_for_file: always_specify_types, use_build_context_synchronously

import "package:base/base.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:sasat_toko/constant/preference_key.dart";
import "package:sasat_toko/helper/formats.dart";
import "package:sasat_toko/helper/generals.dart";
import "package:sasat_toko/helper/preferences.dart";
import "package:sasat_toko/main_bloc.dart";
import "package:sasat_toko/main_event.dart";
import "package:sasat_toko/module/account/account_bloc.dart";
import "package:sasat_toko/module/account/account_state.dart";
import "package:smooth_corner/smooth_corner.dart";

class AccountPage extends StatefulWidget {
  const AccountPage({
    super.key,
  });

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) async {},
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: AppColors.inverseSurface(),
          statusBarIconBrightness: AppColors.brightness(),
        ),
        child: Scaffold(
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
    return Container(
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
                    Text(
                      Formats.spell("Satset"),
                      style: TextStyle(
                        color: AppColors.surface(),
                        fontSize: Dimensions.text20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Image.network(
                Formats.spell(
                    "https://t4.ftcdn.net/jpg/00/88/53/89/360_F_88538986_5Bi4eJ667pocsO3BIlbN4fHKz8yUFSuA.jpg"),
                width: Dimensions.size50,
                height: Dimensions.size50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: Dimensions.size50,
                  height: Dimensions.size50,
                  decoration: ShapeDecoration(
                    color: AppColors.primary(),
                    shape: SmoothRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.size10),
                      smoothness: 1,
                      side: BorderSide(color: AppColors.onPrimary()),
                    ),
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: Dimensions.size30,
                    color: AppColors.onPrimary(),
                  ),
                ),
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return SmoothClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.size10),
                    smoothness: 1,
                    side: BorderSide(color: AppColors.surface()),
                    child: child,
                  );
                },
              ),
            ],
          ),
          SizedBox(height: Dimensions.size20),
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
          help(),
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
            "setting".tr(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Dimensions.text16,
            ),
          ),
          SizedBox(
            height: Dimensions.size10,
          ),
          ListTile(
            onTap: () async {},
            shape: SmoothRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.size10),
              smoothness: 1,
              side: BorderSide(color: AppColors.outline()),
            ),
            tileColor: AppColors.surfaceContainerLowest(),
            leading: const Icon(Icons.key),
            title: Text(
              "change_pin".tr(),
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
          SizedBox(
            height: Dimensions.size10,
          ),
          ListTile(
            onTap: () async {
              List<SpinnerItem> spinnerItems = [
                SpinnerItem(
                  identity: Language.BAHASA,
                  description: "Bahasa",
                  selected: Language.valueOf("locale".tr()) == Language.BAHASA,
                ),
                SpinnerItem(
                  identity: Language.ENGLISH,
                  description: "English",
                  selected: Language.valueOf("locale".tr()) == Language.ENGLISH,
                ),
              ];

              await BaseSheets.spinner(
                title: "change_language".tr(),
                context: Navigators.sideSheetNavigatorState.currentContext,
                spinnerItems: spinnerItems,
                onSelected: (selectedItem) async {
                  Generals.changeLanguage(locale: selectedItem.identity.locale);

                  setState(() {});
                },
              );
            },
            shape: SmoothRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.size10),
              smoothness: 1,
              side: BorderSide(color: AppColors.outline()),
            ),
            tileColor: AppColors.surfaceContainerLowest(),
            leading: const Icon(Icons.translate),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    "change_language".tr(),
                  ),
                ),
                Text(
                  Language.valueOf("locale".tr()) == Language.ENGLISH
                      ? "English"
                      : "Bahasa",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary(),
                    fontSize: Dimensions.text14,
                  ),
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
          SizedBox(
            height: Dimensions.size10,
          ),
          ListTile(
            onTap: () {
              int value = Preferences.getInt(PreferenceKey.THEME_MODE) ?? 0;

              List<SpinnerItem> spinnerItems = [
                SpinnerItem(
                  identity: 0,
                  description: "system".tr(),
                  selected: value == 0,
                ),
                SpinnerItem(
                  identity: 1,
                  description: "light".tr(),
                  selected: value == 1,
                ),
                SpinnerItem(
                  identity: 2,
                  description: "dark".tr(),
                  selected: value == 2,
                ),
              ];

              BaseSheets.spinner(
                title: "theme_mode".tr(),
                context: Navigators.sideSheetNavigatorState.currentContext,
                spinnerItems: spinnerItems,
                onSelected: (selectedItem) async {
                  context.read<MainBloc>().add(
                        MainThemeChanged(
                          value: selectedItem.identity,
                        ),
                      );
                },
              );
            },
            shape: SmoothRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.size10),
              smoothness: 1,
              side: BorderSide(color: AppColors.outline()),
            ),
            tileColor: AppColors.surfaceContainerLowest(),
            leading: AppColors.darkMode()
                ? const Icon(Icons.dark_mode)
                : const Icon(Icons.light_mode),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    "theme_mode".tr(),
                  ),
                ),
                Text(
                  translateTheme(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary(),
                    fontSize: Dimensions.text14,
                  ),
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget help() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.size20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "help".tr(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Dimensions.text16,
            ),
          ),
          SizedBox(
            height: Dimensions.size10,
          ),
          ListTile(
            shape: SmoothRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.size10),
              smoothness: 1,
              side: BorderSide(color: AppColors.outline()),
            ),
            tileColor: AppColors.surfaceContainerLowest(),
            leading: const Icon(Icons.security),
            title: Text(
              "version".tr(),
            ),
            trailing: FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!.version,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary(),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
          SizedBox(
            height: Dimensions.size10,
          ),
          ListTile(
            onTap: () {
              BaseDialogs.confirmation(
                title: "sign_out".tr(),
                message: "are_you_sure_want_to_sign_out".tr(),
                positiveCallback: () async {
                  await Generals.signOut(context);
                },
              );
            },
            tileColor: AppColors.errorContainer(),
            leading: Icon(
              Icons.logout,
              color: AppColors.onErrorContainer(),
            ),
            title: Text(
              "sign_out".tr(),
              style: TextStyle(
                color: AppColors.onErrorContainer(),
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: AppColors.onErrorContainer(),
            ),
          ),
        ],
      ),
    );
  }

  String translateTheme() {
    int value = Preferences.getInt(PreferenceKey.THEME_MODE) ?? 0;

    if (value == 1) {
      return "light".tr();
    } else if (value == 2) {
      return "dark".tr();
    } else {
      return "system".tr();
    }
  }
}
