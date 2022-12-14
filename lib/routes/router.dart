import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/analytichs/analytics_service.dart';
import 'package:wallpaper/logger/logger.dart';
import 'package:wallpaper/popup/editProfilePanel.dart';
import 'package:wallpaper/routes/routes_constans.dart';
import 'package:wallpaper/ui/pages/categories/colorScreen.dart';
import 'package:wallpaper/ui/pages/download/downloadScreen.dart';
import 'package:wallpaper/ui/pages/download/downloadWallpaperViewScreen.dart';
import 'package:wallpaper/ui/pages/favourite/favouriteSetupScreen.dart';
import 'package:wallpaper/ui/pages/favourite/favouriteSetupViewScreen.dart';
import 'package:wallpaper/ui/pages/favourite/favouriteWallScreen.dart';
import 'package:wallpaper/ui/pages/favourite/favouriteWallViewScreen.dart';
import 'package:wallpaper/ui/pages/home/collections/collectionViewScreen.dart';
import 'package:wallpaper/ui/pages/home/core/pageManager.dart';
import 'package:wallpaper/ui/pages/home/core/wallpaperFilterScreen.dart';
import 'package:wallpaper/ui/pages/home/core/wallpaperScreen.dart';
import 'package:wallpaper/ui/pages/payments/upgrade.dart';
import 'package:wallpaper/ui/pages/profile_page/aboutScreen.dart';
import 'package:wallpaper/ui/pages/profile_page/editSetupDetails.dart';
import 'package:wallpaper/ui/pages/profile_page/followersScreen.dart';
import 'package:wallpaper/ui/pages/profile_page/profileScreen.dart';
import 'package:wallpaper/ui/pages/profile_page/profileSetupViewScreen.dart';
import 'package:wallpaper/ui/pages/profile_page/profileWallViewScreen.dart';
import 'package:wallpaper/ui/pages/profile_page/reviewScreen.dart';
import 'package:wallpaper/ui/pages/profile_page/settings.dart';
import 'package:wallpaper/ui/pages/profile_page/sharePrismScreen.dart';
import 'package:wallpaper/ui/pages/profile_page/themeView.dart';
import 'package:wallpaper/ui/pages/profile_page/userProfileSetupViewScreen.dart';
import 'package:wallpaper/ui/pages/profile_page/userProfileWallViewScreen.dart';
import 'package:wallpaper/ui/pages/search/searchScreen.dart';
import 'package:wallpaper/ui/pages/search/searchWallpaperScreen.dart';
import 'package:wallpaper/ui/pages/search/userSearch.dart';
import 'package:wallpaper/ui/pages/setup/setupScreen.dart';
import 'package:wallpaper/ui/pages/setup/setupViewScreen.dart';
import 'package:wallpaper/ui/pages/setup/shareSetupViewScreen.dart';
import 'package:wallpaper/ui/pages/share/shareWallViewScreen.dart';
import 'package:wallpaper/ui/pages/upload/draftSetupScreen.dart';
import 'package:wallpaper/ui/pages/upload/editWallScreen.dart';
import 'package:wallpaper/ui/pages/upload/setupGuidelines.dart';
import 'package:wallpaper/ui/pages/upload/uploadSetupScreen.dart';
import 'package:wallpaper/ui/pages/upload/uploadWallScreen.dart';
import 'package:wallpaper/undefinedScreen.dart';
import 'package:image/image.dart' as imagelib;

List<String> navStack = ['Home'];

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case splashRoute:
      navStack.add("Splash");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: splashRoute);
      return CupertinoPageRoute(
          builder: (context) => Container(
                child: Text("splass"),
              ));
    case searchRoute:
      navStack.add("Search");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: searchRoute);
      return PageRouteBuilder(
          transitionDuration: const Duration(), pageBuilder: (context, animation1, animation2) => SearchScreen());
    case followerProfileRoute:
      navStack.add("Follower Profile");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: followerProfileRoute);
      return CupertinoPageRoute(builder: (context) => ProfileScreen(settings.arguments as List?));
    case homeRoute:
      navStack.add("Home");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: homeRoute);
      return PageRouteBuilder(
          transitionDuration: const Duration(), pageBuilder: (context, animation1, animation2) => PageManager());
    case downloadRoute:
      navStack.add("Downloads");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: downloadRoute);
      return CupertinoPageRoute(builder: (context) => DownloadScreen());
    case reviewRoute:
      navStack.add("Review Screen");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: reviewRoute);
      return CupertinoPageRoute(builder: (context) => ReviewScreen());
    case favWallRoute:
      navStack.add("Fav Walls");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: favWallRoute);
      return CupertinoPageRoute(builder: (context) => const FavouriteWallpaperScreen());
    case favSetupRoute:
      navStack.add("Fav Setups");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: favSetupRoute);
      return CupertinoPageRoute(builder: (context) => const FavouriteSetupScreen());
    case editProfileRoute:
      navStack.add("Edit Profile");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: editProfileRoute);
      return CupertinoPageRoute(builder: (context) => const EditProfilePanel());
    case profileRoute:
      navStack.add("Profile");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: profileRoute);
      return PageRouteBuilder(
          transitionDuration: const Duration(),
          pageBuilder: (context, animation1, animation2) => ProfileScreen(settings.arguments as List?));
    case premiumRoute:
      navStack.add("Buy Premium");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: premiumRoute);
      return CupertinoPageRoute(builder: (context) => UpgradeScreen());
    case colorRoute:
      navStack.add("Color");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: colorRoute);
      return CupertinoPageRoute(builder: (context) => ColorScreen(arguments: settings.arguments as List?));
    case collectionViewRoute:
      navStack.add("CollectionsView");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: collectionViewRoute);
      return CupertinoPageRoute(builder: (context) => CollectionViewScreen(arguments: settings.arguments as List?));
    case wallpaperRoute:
      navStack.add("Wallpaper");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: wallpaperRoute);
      return CupertinoPageRoute(
          builder: (context) => WallpaperScreen(arguments: settings.arguments as List?), fullscreenDialog: true);
    case searchWallpaperRoute:
      navStack.add("Search Wallpaper");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: searchWallpaperRoute);
      return CupertinoPageRoute(
          builder: (context) => SearchWallpaperScreen(arguments: settings.arguments as List?), fullscreenDialog: true);
    case downloadWallpaperRoute:
      navStack.add("DownloadedWallpaper");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: downloadWallpaperRoute);
      return CupertinoPageRoute(
          builder: (context) => DownloadWallpaperScreen(arguments: settings.arguments as List?),
          fullscreenDialog: true);
    case shareRoute:
      navStack.add("SharedWallpaper");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: shareRoute);
      return CupertinoPageRoute(
          builder: (context) => ShareWallpaperViewScreen(arguments: settings.arguments as List?),
          fullscreenDialog: true);
    case shareSetupViewRoute:
      navStack.add("SharedSetup");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: shareSetupViewRoute);
      return CupertinoPageRoute(
          builder: (context) => ShareSetupViewScreen(arguments: settings.arguments as List?), fullscreenDialog: true);
    case favWallViewRoute:
      navStack.add("FavouriteWallpaper");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: favWallViewRoute);
      return CupertinoPageRoute(
          builder: (context) => FavWallpaperViewScreen(arguments: settings.arguments as List?), fullscreenDialog: true);
    case favSetupViewRoute:
      navStack.add("Favourite Setup View");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: favSetupViewRoute);
      return CupertinoPageRoute(
          builder: (context) => FavSetupViewScreen(arguments: settings.arguments as List?), fullscreenDialog: true);
    case setupRoute:
      navStack.add("Setups");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: setupRoute);
      return PageRouteBuilder(
          transitionDuration: const Duration(), pageBuilder: (context, animation1, animation2) => const SetupScreen());
    case setupViewRoute:
      navStack.add("SetupView");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: setupViewRoute);
      return CupertinoPageRoute(
          builder: (context) => SetupViewScreen(arguments: settings.arguments as List?), fullscreenDialog: true);
    case profileSetupViewRoute:
      navStack.add("ProfileSetupView");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: profileSetupViewRoute);
      return CupertinoPageRoute(
          builder: (context) => ProfileSetupViewScreen(
                arguments: settings.arguments as List?,
              ),
          fullscreenDialog: true);
    case profileWallViewRoute:
      navStack.add("ProfileWallpaper");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: profileWallViewRoute);
      return CupertinoPageRoute(
          builder: (context) => ProfileWallViewScreen(arguments: settings.arguments as List?), fullscreenDialog: true);
    case userProfileWallViewRoute:
      navStack.add("User ProfileWallpaper");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: userProfileWallViewRoute);
      return CupertinoPageRoute(
          builder: (context) => UserProfileWallViewScreen(arguments: settings.arguments as List?),
          fullscreenDialog: true);
    case userProfileSetupViewRoute:
      navStack.add("User ProfileSetup");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: userProfileSetupViewRoute);
      return CupertinoPageRoute(
          builder: (context) => UserProfileSetupViewScreen(arguments: settings.arguments as List?),
          fullscreenDialog: true);
    case themeViewRoute:
      navStack.add("Themes");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: themeViewRoute);
      return CupertinoPageRoute(builder: (context) => ThemeView());
    case editWallRoute:
      navStack.add("Edit Wallpaper");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: editWallRoute);
      return CupertinoPageRoute(
          builder: (context) => EditWallScreen(arguments: settings.arguments as List?), fullscreenDialog: true);
    case uploadSetupRoute:
      navStack.add("Upload Setup");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: uploadSetupRoute);
      return CupertinoPageRoute(
          builder: (context) => UploadSetupScreen(arguments: settings.arguments as List?), fullscreenDialog: true);
    case editSetupDetailsRoute:
      navStack.add("Edit Setup Details");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: editSetupDetailsRoute);
      return CupertinoPageRoute(
          builder: (context) => EditSetupReviewScreen(arguments: settings.arguments as List?), fullscreenDialog: true);
    case draftSetupRoute:
      navStack.add("Draft Setup");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: draftSetupRoute);
      return CupertinoPageRoute(builder: (context) => const DraftSetupScreen(), fullscreenDialog: true);
    case userSearchRoute:
      navStack.add("Search Users");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: userSearchRoute);
      return CupertinoPageRoute(
        builder: (context) => const UserSearch(),
      );
    case setupGuidelinesRoute:
      navStack.add("Setup Guidelines");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: setupGuidelinesRoute);
      return CupertinoPageRoute(builder: (context) => const SetupGuidelinesScreen(), fullscreenDialog: true);
    case uploadWallRoute:
      navStack.add("Add");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: uploadWallRoute);
      return CupertinoPageRoute(
          builder: (context) => UploadWallScreen(arguments: settings.arguments as List?), fullscreenDialog: true);
    case aboutRoute:
      navStack.add("About Prism");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: aboutRoute);
      return CupertinoPageRoute(builder: (context) => AboutScreen(), fullscreenDialog: true);
    case settingsRoute:
      navStack.add("Settings");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: settingsRoute);
      return CupertinoPageRoute(builder: (context) => const SettingsScreen(), fullscreenDialog: true);
    case sharePrismRoute:
      navStack.add("Share Prism");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: sharePrismRoute);
      return CupertinoPageRoute(builder: (context) => SharePrismScreen(), fullscreenDialog: true);
    case wallpaperFilterRoute:
      navStack.add("Wallpaper Filter");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: wallpaperFilterRoute);
      return CupertinoPageRoute(
          builder: (context) => WallpaperFilterScreen(
                image: (settings.arguments as List?)![0] as imagelib.Image,
                finalImage: (settings.arguments as List?)![1] as imagelib.Image,
                filename: (settings.arguments as List?)![2] as String,
                finalFilename: (settings.arguments as List?)![3] as String,
              ),
          fullscreenDialog: true);
    case followersRoute:
      navStack.add("Followers");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: followersRoute);
      return CupertinoPageRoute(
          builder: (context) => FollowersScreen(
                arguments: settings.arguments as List?,
              ));
    default:
      navStack.add("undefined");
      logger.d(navStack.toString());
      analytics.setCurrentScreen(screenName: "/undefined");
      return CupertinoPageRoute(
        builder: (context) => UndefinedScreen(
          name: settings.name,
        ),
      );
  }
}
