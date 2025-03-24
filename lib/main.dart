import "dart:io";

import "package:base/base.dart";
import "package:easy_localization/easy_localization.dart" as el;
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_web_plugins/url_strategy.dart";
import "package:get/get.dart";
import "package:go_router/go_router.dart";
import "package:intl/date_symbol_data_local.dart";
import "package:loader_overlay/loader_overlay.dart";
import "package:lottie/lottie.dart";
import "package:provider/provider.dart";
import "package:sasat_toko/helper/generals.dart";
import "package:sasat_toko/helper/timers.dart";
import "package:sasat_toko/main_bloc.dart";
import "package:sasat_toko/main_state.dart";
import "package:sasat_toko/module/account/account_bloc.dart";
import "package:sasat_toko/module/account/account_page.dart";
import "package:sasat_toko/module/home/home_bloc.dart";
import "package:sasat_toko/module/home/home_page.dart";
import "package:sasat_toko/module/root/root_bloc.dart";
import "package:sasat_toko/module/root/root_page.dart";
import "package:sasat_toko/module/sign_in/sign_in_bloc.dart";
import "package:sasat_toko/module/sign_in/sign_in_page.dart";
import "package:sasat_toko/module/sign_up/sign_up_bloc.dart";
import "package:sasat_toko/module/sign_up/sign_up_page.dart";
import "package:sasat_toko/shared.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:smooth_corner/smooth_corner.dart";

final goRouter = GoRouter(
  initialLocation: "/",
  navigatorKey: Get.key,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: "/sign-in",
      builder: (context, state) {
        return const SignInPage();
      },
    ),
    GoRoute(
      path: "/sign-up",
      builder: (context, state) {
        return const SignUpPage();
      },
    ),
    //  GoRoute(
    //   path: "/imei-list",
    //   builder: (context, state) {
    //     return  ImeiPage();
    //   },
    // ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return RootPage(statefulNavigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/",
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: HomePage());
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/account",
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: AccountPage());
              },
            ),
          ],
        ),
      ],
      redirect: (context, state) async {
        final isLoggedIn = await isAuthenticated();

        if (!isLoggedIn) {
          return "/sign-in";
        }
        return null;
      },
    ),
    GoRoute(
      path: "/",
      redirect: (context, state) {
        if (Shared.ACCOUNT == null) {
          return "/sign-in";
        }

        return null;
      },
      routes: [],
    ),
  ],
);

Future<bool> isAuthenticated() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("auth_token");
  return token != null && token.isNotEmpty;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = BaseHttpOverrides();

  AppColors.lightColorScheme = const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xffa1c4fd), // Biru pastel lembut
    surfaceTint: Color(0xffc3aed6), // Ungu pastel lembut
    onPrimary: Color(0xffffffff),
    primaryContainer: Color(0xffd4eaf7), // Biru pastel terang
    onPrimaryContainer: Color(0xff2c3e50),
    secondary: Color(0xfff6d365), // Kuning pastel
    onSecondary: Color(0xff000000),
    secondaryContainer: Color(0xfffff8d2), // Kuning terang
    onSecondaryContainer: Color(0xff4d4800),
    tertiary: Color(0xffc3aed6), // Ungu pastel
    onTertiary: Color(0xffffffff),
    tertiaryContainer: Color(0xffe6ccff), // Ungu terang
    onTertiaryContainer: Color(0xff4a235a),
    error: Color(0xfff7a1a1), // Merah pastel
    onError: Color(0xffffffff),
    errorContainer: Color(0xffffdad6),
    onErrorContainer: Color(0xff93000a),
    surface: Color(0xfff8f9fa), // Abu-abu sangat terang
    onSurface: Color(0xff2c3e50),
    onSurfaceVariant: Color(0xff5d6d7e),
    outline: Color(0xffaeb6bf),
    outlineVariant: Color(0xffccd1d9),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xff2c3e50),
    inversePrimary: Color(0xff7eb3e7), // Biru pastel sedang
    primaryFixed: Color(0xffd4eaf7),
    onPrimaryFixed: Color(0xff102000),
    primaryFixedDim: Color(0xffa1c4fd),
    onPrimaryFixedVariant: Color(0xff2c3e50),
    secondaryFixed: Color(0xfffff8d2),
    onSecondaryFixed: Color(0xff1e1c00),
    secondaryFixedDim: Color(0xfff6d365),
    onSecondaryFixedVariant: Color(0xff4d4800),
    tertiaryFixed: Color(0xffe6ccff),
    onTertiaryFixed: Color(0xff001d32),
    tertiaryFixedDim: Color(0xffc3aed6),
    onTertiaryFixedVariant: Color(0xff4a235a),
    surfaceDim: Color(0xffe5e8ec),
    surfaceBright: Color(0xfffafcff),
    surfaceContainerLowest: Color(0xffffffff),
    surfaceContainerLow: Color(0xfff3f4f6),
    surfaceContainer: Color(0xffeeeff2),
    surfaceContainerHigh: Color(0xffe8e9ed),
    surfaceContainerHighest: Color(0xffe2e3e7),
  );

  AppColors.darkColorScheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xff7eb3e7), // Biru pastel gelap
    surfaceTint: Color(0xffc3aed6), // Ungu pastel lembut
    onPrimary: Color(0xff1f3701),
    primaryContainer: Color(0xff2c3e50),
    onPrimaryContainer: Color(0xffd4eaf7),
    secondary: Color(0xfff6d365), // Kuning pastel
    onSecondary: Color(0xff353200),
    secondaryContainer: Color(0xff4d4800),
    onSecondaryContainer: Color(0xfffff8d2),
    tertiary: Color(0xffc3aed6), // Ungu pastel
    onTertiary: Color(0xff003352),
    tertiaryContainer: Color(0xff4a235a),
    onTertiaryContainer: Color(0xffe6ccff),
    error: Color(0xfff7a1a1), // Merah pastel
    onError: Color(0xff690005),
    errorContainer: Color(0xff93000a),
    onErrorContainer: Color(0xffffdad6),
    surface: Color(0xff121212), // Dark mode abu-abu gelap
    onSurface: Color(0xffe2e3d8),
    onSurfaceVariant: Color(0xffc5c8ba),
    outline: Color(0xff8f9285),
    outlineVariant: Color(0xff44483d),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xffe2e3d8),
    inversePrimary: Color(0xff4c662b),
    primaryFixed: Color(0xffd4eaf7),
    onPrimaryFixed: Color(0xff102000),
    primaryFixedDim: Color(0xffa1c4fd),
    onPrimaryFixedVariant: Color(0xff2c3e50),
    secondaryFixed: Color(0xfffff8d2),
    onSecondaryFixed: Color(0xff1e1c00),
    secondaryFixedDim: Color(0xfff6d365),
    onSecondaryFixedVariant: Color(0xff4d4800),
    tertiaryFixed: Color(0xffe6ccff),
    onTertiaryFixed: Color(0xff001d32),
    tertiaryFixedDim: Color(0xffc3aed6),
    onTertiaryFixedVariant: Color(0xff4a235a),
    surfaceDim: Color(0xff12140e),
    surfaceBright: Color(0xff383a32),
    surfaceContainerLowest: Color(0xff0c0f09),
    surfaceContainerLow: Color(0xff1a1c16),
    surfaceContainer: Color(0xff1e201a),
    surfaceContainerHigh: Color(0xff282b24),
    surfaceContainerHighest: Color(0xff33362e),
  );

  usePathUrlStrategy();
  initializeDateFormatting();
  GoRouter.optionURLReflectsImperativeAPIs = true;

  await el.EasyLocalization.ensureInitialized();
  await BasePreferences.getInstance().init();
  await Generals.self();

  runApp(
    el.EasyLocalization(
      supportedLocales: const [Locale("en"), Locale("id")],
      path: "assets/i18n",
      useFallbackTranslations: true,
      fallbackLocale: const Locale("en"),
      saveLocale: true,
      startLocale: const Locale("en"),
      child: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final ValueNotifier<String> valueNotifier = ValueNotifier("");

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>?
      scaffoldFeatureController;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => MainBloc()),
        BlocProvider(create: (BuildContext context) => SignInBloc()),
        BlocProvider(create: (BuildContext context) => SignUpBloc()),
        BlocProvider(create: (BuildContext context) => RootBloc()),
        BlocProvider(create: (BuildContext context) => HomeBloc()),
        BlocProvider(create: (BuildContext context) => AccountBloc()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Timers.getInstance()),
        ],
        child: GlobalLoaderOverlay(
          useDefaultLoading: false,
          overlayWidget: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  "assets/lottie/loading.json",
                  frameRate: const FrameRate(60),
                  width: Dimensions.size100,
                  height: Dimensions.size100,
                  repeat: true,
                ),
                Text(
                  "Loading...",
                  style: TextStyle(
                    fontSize: Dimensions.text20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          overlayColor: Colors.black,
          overlayOpacity: 0.8,
          child: DismissKeyboard(
            child: BlocBuilder<MainBloc, MainState>(
              builder: (context, state) {
                return MaterialApp.router(
                  scrollBehavior: BaseScrollBehavior(),
                  scaffoldMessengerKey: rootScaffoldMessengerKey,
                  title: "sasat-toko",
                  routerConfig: goRouter,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    useMaterial3: true,
                    fontFamily: "Manrope",
                    colorScheme: AppColors.lightColorScheme,
                    filledButtonTheme: FilledButtonThemeData(
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: SmoothRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.size10),
                          smoothness: 1,
                        ),
                        padding: EdgeInsets.all(Dimensions.size20),
                        textStyle: TextStyle(
                          fontSize: Dimensions.text12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    outlinedButtonTheme: OutlinedButtonThemeData(
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: SmoothRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.size10),
                          smoothness: 1,
                        ),
                        padding: EdgeInsets.all(Dimensions.size20),
                        textStyle: TextStyle(
                          fontSize: Dimensions.text12,
                          fontWeight: FontWeight.w500,
                        ),
                        foregroundColor: AppColors.onSurface(),
                        iconColor: AppColors.onSurface(),
                      ),
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: SmoothRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.size10),
                          smoothness: 1,
                        ),
                        padding: EdgeInsets.all(Dimensions.size20),
                        textStyle: TextStyle(
                          fontSize: Dimensions.text12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    iconButtonTheme: IconButtonThemeData(
                      style: IconButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                        minimumSize:
                            Size.square(Dimensions.size45 + Dimensions.size3),
                      ),
                    ),
                  ),
                  darkTheme: ThemeData(
                    useMaterial3: true,
                    fontFamily: "Manrope",
                    colorScheme: AppColors.darkColorScheme,
                    filledButtonTheme: FilledButtonThemeData(
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: SmoothRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.size10),
                          smoothness: 1,
                        ),
                        padding: EdgeInsets.all(Dimensions.size20),
                        textStyle: TextStyle(
                          fontSize: Dimensions.text12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    outlinedButtonTheme: OutlinedButtonThemeData(
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: SmoothRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.size10),
                          smoothness: 1,
                        ),
                        padding: EdgeInsets.all(Dimensions.size20),
                        textStyle: TextStyle(
                          fontSize: Dimensions.text12,
                          fontWeight: FontWeight.w500,
                        ),
                        foregroundColor: AppColors.onSurface(),
                        iconColor: AppColors.onSurface(),
                      ),
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: SmoothRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.size10),
                          smoothness: 1,
                        ),
                        padding: EdgeInsets.all(Dimensions.size20),
                        textStyle: TextStyle(
                          fontSize: Dimensions.text12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    iconButtonTheme: IconButtonThemeData(
                      style: IconButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                        minimumSize:
                            Size.square(Dimensions.size45 + Dimensions.size3),
                      ),
                    ),
                  ),
                  themeMode: state.themeMode,
                  builder: (BuildContext context, Widget? child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: const TextScaler.linear(1.0)),
                      child: child ?? Container(),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class DismissKeyboard extends StatelessWidget {
  final Widget child;

  const DismissKeyboard({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}

class SnackContent extends StatelessWidget {
  final ValueNotifier<String> message;

  const SnackContent(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: message,
      builder: (_, msg, __) => Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.onError(),
        ),
      ),
    );
  }
}
