import 'package:flutter/material.dart';
import 'package:wallpaper/global/categoryMenu.dart';
import 'package:wallpaper/main.dart' as main;
import 'package:provider/provider.dart';
import 'package:wallpaper/global/categoryProvider.dart';
import 'package:wallpaper/logger/logger.dart';
import 'package:wallpaper/popup/changelogPopUp.dart';
import 'package:wallpaper/routes/router.dart';
import 'package:wallpaper/ui/pages/home/wallpapers/loading.dart';
import 'package:wallpaper/ui/pages/home/wallpapers/pexelsGrid.dart';
import 'package:wallpaper/ui/pages/home/wallpapers/wallhavenGrid.dart';
import 'package:wallpaper/ui/pages/home/wallpapers/wallpaperGrid.dart';

// final FirebaseMessaging f = FirebaseMessaging.instance;

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List?>? _future;

  Future<bool> onWillPop() async {
    final choice = choices[0];
    if (Provider.of<CategorySupplier>(context, listen: false).selectedChoice != choice) {
      Provider.of<CategorySupplier>(context, listen: false).changeSelectedChoice(choice as CategoryMenu);
      Provider.of<CategorySupplier>(context, listen: false).changeWallpaperFuture(choice, "r");
      return false;
    }
    if (navStack.length > 1) navStack.removeLast();
    logger.d(navStack.toString());
    logger.d("Bye! Have a good day!");
    return true;
  }

  late bool isNew;
  @override
  void initState() {
    super.initState();
    if (main.prefs.get('subscribedToRecommendations', defaultValue: false) as bool) {
    } else {
      // f.subscribeToTopic('recommendations');
      // f.subscribeToTopic('posts');
      main.prefs.put('subscribedToRecommendations', true);
    }
    isNew = true;
    _updateToken();
    _future = Future.delayed(const Duration())
        .then((value) => Provider.of<CategorySupplier>(context, listen: false).wallpaperFutureRefresh);
  }

  void _updateToken() {
    // f.requestPermission();
  }

  void showChangelogCheck(BuildContext context) {
    // final newDevice = main.prefs.get("newDevice");
    // if (newDevice == null) {
    //   showChangelog(context, () {
    //     setState(() {
    //       isNew = false;
    //     });
    //   });
    //   main.prefs.put("newDevice", false);
    // } else {
    //   main.prefs.put("newDevice", false);
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (isNew) {
      Future.delayed(const Duration()).then((value) => showChangelogCheck(context));
    }
    return WillPopScope(
      onWillPop: onWillPop,
      child: FutureBuilder<List?>(
        future: _future, // async work
        builder: (BuildContext context, AsyncSnapshot<List?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const LoadingCards();
            case ConnectionState.none:
              return const LoadingCards();
            default:
              if (snapshot.hasError) {
                return RefreshIndicator(
                    onRefresh: () async {
                      // ignore: unnecessary_statements
                      _future;
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Spacer(),
                        Center(child: Text("Can't connect to the Servers!")),
                        Spacer(),
                      ],
                    ));
              } else {
                if (Provider.of<CategorySupplier>(context).selectedChoice.provider == "WallHaven") {
                  return WallHavenGrid(provider: Provider.of<CategorySupplier>(context).selectedChoice.provider);
                } else if (Provider.of<CategorySupplier>(context).selectedChoice.provider == "Pexels") {
                  return PexelsGrid(provider: Provider.of<CategorySupplier>(context).selectedChoice.provider);
                } else {
                  return WallpaperGrid(provider: Provider.of<CategorySupplier>(context).selectedChoice.provider);
                }
              }
          }
        },
      ),
    );
  }
}
