import "package:base/base.dart";
import "package:dio/dio.dart" as dio;
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:go_router/go_router.dart";
import "package:sasat_toko/api/api_manager.dart";
import "package:sasat_toko/constant/preference_key.dart";
import "package:sasat_toko/helper/preferences.dart";
import "package:sasat_toko/model/account.dart";
import "package:sasat_toko/shared.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:url_launcher/url_launcher_string.dart";

class Generals {
  static BuildContext? context() {
    return Get.context;
  }

  static GlobalKey<NavigatorState> navigatorState() {
    return Get.key;
  }

  static Future<void> self() async {
    if (Preferences.contain(PreferenceKey.SESSION_ID)) {
      dio.Response response = await ApiManager.account();

      if (response.statusCode == 200) {
        Shared.ACCOUNT = Account().parse(response.data);
      }
    }
  }

  static Future<void> signOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("SESSION_ID");
    await prefs.remove("auth_token");

    Shared.ACCOUNT = null;

    if (context.mounted) {
      context.go("/sign-in");
    }
  }

  static void changeLanguage({
    required String locale,
  }) async {
    if (context() != null) {
      context()!.setLocale(Locale.fromSubtags(languageCode: locale));

      Locale newLocale = Locale(locale);

      await context()!.setLocale(newLocale);

      Get.updateLocale(newLocale);
    }
  }

  static Future<void> launchUrl(String url) async {
    try {
      if (!await launchUrlString(
        url,
        mode: LaunchMode.externalNonBrowserApplication,
      )) {
        throw Exception("Could not launch $url");
      }
    } catch (e) {
      BaseOverlays.error(message: e.toString());
    }
  }
}
