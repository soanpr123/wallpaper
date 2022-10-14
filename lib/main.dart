import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/analytichs/analytics_service.dart';
import 'package:wallpaper/auth/badgeModel.dart';
import 'package:wallpaper/auth/transactionModel.dart';
import 'package:wallpaper/auth/userModel.dart';
import 'package:wallpaper/data/ads/adsNotifier.dart';
import 'package:wallpaper/data/favourites/provider/favouriteProvider.dart';
import 'package:wallpaper/data/favourites/provider/favouriteSetupProvider.dart';
import 'package:wallpaper/data/profile/wallpaper/getUserProfile.dart';
import 'package:wallpaper/data/profile/wallpaper/profileSetupProvider.dart';
import 'package:wallpaper/data/profile/wallpaper/profileWallProvider.dart';
import 'package:wallpaper/data/setups/provider/setupProvider.dart';
import 'package:wallpaper/data/user/user_notifier.dart';
import 'package:wallpaper/firebase_options.dart';
import 'package:wallpaper/global/categoryProvider.dart';
import 'package:wallpaper/locator/locator.dart';
import 'package:wallpaper/logger/logger.dart';
import 'package:wallpaper/routes/router.dart' as router;
import 'package:wallpaper/themes/toasts.dart' as toasts;
import 'package:wallpaper/global/globals.dart' as globals;
import 'package:wallpaper/themes/darkThemeModel.dart';
import 'package:wallpaper/themes/themeModeProvider.dart';
import 'package:wallpaper/themes/themeModel.dart';
import 'package:wallpaper/ui/pages/home/core/pageManager.dart';
import 'package:wallpaper/ui/pages/home/wallpapers/paletteNotifier.dart';
import 'package:wallpaper/ui/pages/onboarding/onboardingScreen.dart';
import 'package:wallpaper/ui/pages/payments/upgrade.dart';
import 'package:wallpaper/undefinedScreen.dart';

late Box prefs;
Directory? dir;
String? currentThemeID;
String? currentDarkThemeID;
String? currentMode;
Color? lightAccent;
Color? darkAccent;
bool? hqThumbs;
late bool optimisedWallpapers;
int? categories;
int? purity;
String userHiveKey = "WallUserV2-1";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details, forceReport: true);
  };
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {
    getApplicationDocumentsDirectory().then((dir) async {
      Hive.init(dir.path);
      // await Hive.deleteBoxFromDisk('prefs');
      // Hive.ignoreTypeId<PrismUsers>(33);
      // Hive.registerAdapter(WallUsersAdapter());
      // Hive.registerAdapter<InAppNotif>(InAppNotifAdapter());
      Hive.registerAdapter<WallUsersV2>(WallUsersV2Adapter());
      Hive.registerAdapter<WallTransaction>(WallTransactionAdapter());
      Hive.registerAdapter<Badge>(BadgeAdapter());
      // await Hive.openBox<InAppNotif>('inAppNotifs');
      await Hive.openBox('setups');
      await Hive.openBox('localFav');
      await Hive.openBox('appsCache');
      prefs = await Hive.openBox('prefs');
      if (prefs.get("systemOverlayColor") == null) {
        prefs.put("systemOverlayColor", 0xFFE57697);
      }
      currentThemeID = prefs.get('lightThemeID', defaultValue: "kLFrost White")?.toString();
      prefs.put("lightThemeID", currentThemeID);
      currentDarkThemeID = prefs.get('darkThemeID', defaultValue: "kDMaterial Dark")?.toString();
      prefs.put("darkThemeID", currentDarkThemeID);
      currentMode = prefs.get('themeMode')?.toString() ?? "Dark";
      prefs.put("themeMode", currentMode);
      lightAccent = Color(int.parse(prefs.get('lightAccent', defaultValue: "0xffe57697").toString()));
      prefs.put("lightAccent", int.parse(lightAccent.toString().replaceAll("Color(", "").replaceAll(")", "")));
      darkAccent = Color(int.parse(prefs.get('darkAccent', defaultValue: "0xffe57697").toString()));
      prefs.put("darkAccent", int.parse(darkAccent.toString().replaceAll("Color(", "").replaceAll(")", "")));
      optimisedWallpapers = prefs.get('optimisedWallpapers') == true;
      // if (optimisedWallpapers) {
      //   prefs.put('optimisedWallpapers', true);
      // } else {
      prefs.put('optimisedWallpapers', false);
      // }
      categories = prefs.get('WHcategories') as int? ?? 100;
      if (categories == 100) {
        prefs.put('WHcategories', 100);
      } else {
        prefs.put('WHcategories', 111);
      }
      purity = prefs.get('WHpurity') as int? ?? 100;
      if (purity == 100) {
        prefs.put('WHpurity', 100);
      } else {
        prefs.put('WHpurity', 110);
      }
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
          .then((value) => runZonedGuarded<Future<void>>(
                  () {
                    runApp(RestartWidget(
                      child: MultiProvider(providers: [
                        ChangeNotifierProvider<PaletteNotifier>(
                          create: (context) => PaletteNotifier(),
                        ),
                        ChangeNotifierProvider<AdsNotifier>(
                          create: (context) => AdsNotifier(),
                        ),
                        ChangeNotifierProvider<UserProfileProvider>(
                          create: (context) => UserProfileProvider(),
                        ),
                        ChangeNotifierProvider<FavouriteProvider>(
                          create: (context) => FavouriteProvider(),
                        ),
                        ChangeNotifierProvider<FavouriteSetupProvider>(
                          create: (context) => FavouriteSetupProvider(),
                        ),
                        ChangeNotifierProvider<UserNotifier>(create: (context) => locator<UserNotifier>()),
                        // ChangeNotifierProvider<CategorySupplier>(
                        //   create: (context) => CategorySupplier(),
                        // ),
                        ChangeNotifierProvider<SetupProvider>(
                          create: (context) => SetupProvider(),
                        ),
                        ChangeNotifierProvider<ProfileWallProvider>(
                          create: (context) => ProfileWallProvider(),
                        ),
                        ChangeNotifierProvider<ProfileSetupProvider>(
                          create: (context) => ProfileSetupProvider(),
                        ),
                        ChangeNotifierProvider<CategorySupplier>(
                          create: (context) => CategorySupplier(),
                        ),
                        ChangeNotifierProvider<ThemeModel>(
                          create: (context) => ThemeModel(themes[currentThemeID!], lightAccent),
                        ),
                        ChangeNotifierProvider<DarkThemeModel>(
                          create: (context) => DarkThemeModel(darkThemes[currentDarkThemeID!], darkAccent),
                        ),
                        ChangeNotifierProvider<ThemeModeExtended>(
                          create: (context) => ThemeModeExtended(modes[currentMode!]),
                        ),
                      ], child: Main()),
                    ));
                  } as Future<void> Function(), (obj, stacktrace) {
                logger.e(obj, obj, stacktrace);
              }));
    });
  });
}

class Main extends StatefulWidget {
  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  Future<bool> getLoginStatus() async {
    await globals.gAuth.googleSignIn.isSignedIn().then((value) {
      if (value) {
        if (prefs.get("logouteveryoneaugust2021", defaultValue: false) == false) {
          globals.gAuth.signOutGoogle();
          prefs.put("logouteveryoneaugust2021", true);
          toasts.codeSend("Please login again, to enjoy the app!");
        }
      } else if (!value) {
        prefs.put("logouteveryoneaugust2021", true);
      }
      if (value) checkPremium();
      globals.prismUser.loggedIn = value;
      prefs.put(userHiveKey, globals.prismUser);
      return value;
    });
    return false;
  }

  @override
  void initState() {
    FlutterDisplayMode.setHighRefreshRate();
    // localNotification.createNotificationChannel("followers", "Followers", "Get notifications for new followers.", true);
    // localNotification.createNotificationChannel(
    //     "recommendations", "Recommendations", "Get notifications for recommendations from Prism.", true);
    // localNotification.createNotificationChannel(
    //     "posts", "Posts", "Get notifications for posts from artists you follow.", true);
    // localNotification.createNotificationChannel(
    //     "downloads", "Downloads", "Get notifications for download progress of wallpapers.", false);
    getLoginStatus();
    // localNotification.fetchNotificationData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: <NavigatorObserver>[observer],
      onGenerateRoute: router.generateRoute,
      onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => UndefinedScreen(
                name: settings.name,
              )),
      theme: Provider.of<ThemeModel>(context).currentTheme,
      darkTheme: Provider.of<DarkThemeModel>(context).currentTheme,
      themeMode: Provider.of<ThemeModeExtended>(context).currentMode,
      home: ((prefs.get('onboarded_new') as bool?) ?? false) ? const PageManager() : OnboardingScreen(),
    );
  }
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({this.child});
  final Widget? child;
  static void restartApp(BuildContext context) {
    router.navStack = ["Home"];
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(prefs.get('systemOverlayColor') as int),
    ));
    observer = FirebaseAnalyticsObserver(analytics: analytics);
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
    Hive.openBox('prefs').then((prefs) {
      currentThemeID = prefs.get('lightThemeID', defaultValue: "kLFrost White")?.toString();
      prefs.put("lightThemeID", currentThemeID);
      currentDarkThemeID = prefs.get('darkThemeID', defaultValue: "kDMaterial Dark")?.toString();
      prefs.put("darkThemeID", currentDarkThemeID);
      currentMode = prefs.get('themeMode')?.toString() ?? "Dark";
      prefs.put("themeMode", currentMode);
      lightAccent = Color(int.parse(prefs.get('lightAccent', defaultValue: "0xffe57697").toString()));
      prefs.put("lightAccent", int.parse(lightAccent.toString().replaceAll("Color(", "").replaceAll(")", "")));
      darkAccent = Color(int.parse(prefs.get('darkAccent', defaultValue: "0xffe57697").toString()));
      prefs.put("darkAccent", int.parse(darkAccent.toString().replaceAll("Color(", "").replaceAll(")", "")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child!,
    );
  }
}
