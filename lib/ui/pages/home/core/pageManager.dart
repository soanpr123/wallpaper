import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:wallpaper/logger/logger.dart';
import 'package:wallpaper/popup/signInPopUp.dart';
import 'package:wallpaper/routes/router.dart';
import 'package:wallpaper/routes/routes_constans.dart';
import 'package:wallpaper/themes/jam_icons_icons.dart';
import 'package:wallpaper/ui/pages/home/collections/collectionScreen.dart';
import 'package:wallpaper/ui/pages/home/core/followingScreen.dart';
import 'package:wallpaper/ui/pages/home/wallpapers/homeScreen.dart';
import 'package:wallpaper/ui/widgets/home/core/bottomNavBar.dart';
import 'package:wallpaper/global/globals.dart' as globals;
import 'package:wallpaper/ui/widgets/home/core/categoriesBar.dart';
import 'package:wallpaper/main.dart' as main;
import 'package:wallpaper/ui/widgets/home/core/offlineBanner.dart';

TabController? tabController;

class PageManager extends StatelessWidget {
  const PageManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BottomBar(
      child: PageManagerChild(),
    );
  }
}

class PageManagerChild extends StatefulWidget {
  const PageManagerChild({Key? key}) : super(key: key);

  @override
  _PageManagerState createState() => _PageManagerState();
}

class _PageManagerState extends State<PageManagerChild> with SingleTickerProviderStateMixin {
  int page = 0;
  int linkOpened = 0;
  bool notchChecked = false;
  bool result = true;
  final box = Hive.box('localFav');
  String shortcut = "No Action Set";
  Future<void> checkConnection() async {
    result = await InternetConnectionChecker().hasConnection;
    if (result) {
      logger.d("Internet working as expected!");
      setState(() {});
      // return true;
    } else {
      logger.d("Not connected to Internet!");
      setState(() {});
      // return false;
    }
  }

  Future<void> saveFavToLocal() async {
    // if (globals.prismUser.loggedIn) {
    //   await Provider.of<FavouriteProvider>(context, listen: false).getDataBase().then(
    //     (value) {
    //       for (final element in value!) {
    //         box.put(element['id'].toString(), true);
    //       }
    //       box.put('dataSaved', true);
    //     },
    //   );
    // }
  }
  void checkNotch(BuildContext context) {
    final height = MediaQuery.of(context).padding.top;
    globals.hasNotch = height > 24;
    globals.notchSize = height;
    notchChecked = true;
    logger.d('Notch Height = $height');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    final QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      setState(() {
        if (shortcutType != null) shortcut = shortcutType;
      });
      if (shortcutType == 'Follow_Feed') {
        logger.d('Follow_Feed');
        if (globals.followersTab) {
          tabController!.animateTo(1);
        }
      } else if (shortcutType == 'Collections') {
        logger.d('Collections');
        if (globals.followersTab) {
          tabController!.animateTo(2);
        } else {
          tabController!.animateTo(1);
        }
      } else if (shortcutType == 'Setups') {
        logger.d('Setups');
        // navStack.last == "Setups"
        //     ? logger.d("Currently on Setups")
        //     : navStack.last == "Home"
        //         ? Navigator.of(context).pushNamed(setupRoute)
        //         : Navigator.of(context).pushNamed(setupRoute);
      } else if (shortcutType == 'Downloads') {
        logger.d('Downloads');
        // Navigator.pushNamed(context, downloadRoute);
      }
    });
    quickActions.setShortcutItems(<ShortcutItem>[
      // NOTE: This second action icon will only work on Android.
      // In a real world project keep the same file name for both platforms.
      const ShortcutItem(type: 'Follow_Feed', localizedTitle: 'Feed', icon: '@drawable/ic_feed'),
      const ShortcutItem(type: 'Collections', localizedTitle: 'Collections', icon: '@drawable/ic_collections'),
      const ShortcutItem(type: 'Setups', localizedTitle: 'Setups', icon: '@drawable/ic_setups'),
      const ShortcutItem(type: 'Downloads', localizedTitle: 'Downloads', icon: '@drawable/ic_downloads'),
    ]);
    if (box.get('dataSaved', defaultValue: false) as bool) {
    } else {
      saveFavToLocal();
    }
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    if (!notchChecked) {
      checkNotch(context);
    }
    return WillPopScope(
      onWillPop: () async {
        if (tabController!.index != 0) {
          tabController!.animateTo(0);
        } else {
          return true;
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: const PreferredSize(
            preferredSize: Size(double.infinity, 55),
            child: CategoriesBar(),
          ),
          bottom: TabBar(
              controller: tabController,
              indicatorColor: Theme.of(context).accentColor,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(
                  icon: Icon(
                    JamIcons.picture,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                Tab(
                  icon: Icon(
                    JamIcons.user_square,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ]),
        ),
        body: Stack(
          children: <Widget>[
            TabBarView(controller: tabController, children: <Widget>[
              const HomeScreen(),
              if (globals.prismUser.loggedIn == true)
                const FollowingScreen()
              else
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Spacer(),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: const Text(
                          "Please sign-in to view the latest walls from the artists you follow here.",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        googleSignInPopUp(context, () {
                          main.RestartWidget.restartApp(context);
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                      ),
                      child: const SizedBox(
                        width: 60,
                        child: Text(
                          'SIGN-IN',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFE57697),
                            fontSize: 15,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
            ]),
            if (!result) ConnectivityWidget() else Container(),
          ],
        ),
      ),
    );
  }
}
