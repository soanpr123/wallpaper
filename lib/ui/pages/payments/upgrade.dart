import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wallpaper/auth/google_auth.dart';
import 'package:wallpaper/gitkey.dart';
import 'package:wallpaper/main.dart' as main;
import 'package:wallpaper/routes/router.dart';
import 'package:wallpaper/themes/jam_icons_icons.dart';
import 'package:wallpaper/themes/toasts.dart' as toasts;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:purchases_flutter/object_wrappers.dart';

import 'package:wallpaper/global/globals.dart' as globals;
import 'package:wallpaper/logger/logger.dart';
import 'package:wallpaper/ui/animated/loader.dart';
import 'package:wallpaper/ui/pages/payments/components.dart';

CustomerInfo? _purchaserInfo;
PurchasesConfiguration? configuration = PurchasesConfiguration(apiKey)
  ..appUserID = globals.prismUser.id
  ..observerMode = false;
Future<void> checkPremium() async {
  appData.isPro = false;

  await Purchases.configure(configuration!);

  CustomerInfo purchaserInfo;
  try {
    purchaserInfo = await Purchases.getCustomerInfo();
    logger.d(purchaserInfo);
    if (purchaserInfo.entitlements.active.isNotEmpty) {
      appData.isPro = true;
    } else {
      appData.isPro = false;
    }
  } on PlatformException catch (e) {
    logger.d(e.toString());
  }

  globals.prismUser.premium = appData.isPro!;
  main.prefs.put(main.userHiveKey, globals.prismUser);
  FirebaseFirestore.instance.collection(USER_NEW_COLLECTION).doc(globals.prismUser.id).update({
    'premium': appData.isPro!,
  });
  logger.d("USERDATA CASE3");
  logger.d('#### is user pro? ${appData.isPro}');
}

class UpgradeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  Offerings? _offerings;

  @override
  void initState() {
    super.initState();

    initPlatformState();
    fetchData();
  }

  Future<void> initPlatformState() async {
    appData.isPro = false;

    await Purchases.setDebugLogsEnabled(true);
    await Purchases.configure(configuration!);

    CustomerInfo purchaserInfo;
    try {
      purchaserInfo = await Purchases.getCustomerInfo();
      logger.d(purchaserInfo.toString());
      if (purchaserInfo.entitlements.active.isNotEmpty) {
        appData.isPro = true;
      } else {
        appData.isPro = false;
      }
    } on PlatformException catch (e) {
      logger.d(e.toString());
    }

    logger.d('#### is user pro? ${appData.isPro}');
    setState(() {});
  }

  Future<void> fetchData() async {
    CustomerInfo? purchaserInfo;
    try {
      purchaserInfo = await Purchases.getCustomerInfo();
    } on PlatformException catch (e) {
      logger.d(e.toString());
    }

    Offerings? offerings;
    try {
      offerings = await Purchases.getOfferings();
    } on PlatformException catch (e) {
      logger.d(e.toString());
    }
    if (!mounted) return;

    setState(() {
      _purchaserInfo = purchaserInfo;
      _offerings = offerings;
    });
    print(_purchaserInfo);
  }

  @override
  Widget build(BuildContext context) {
    if (_purchaserInfo == null) {
      return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Center(
            child: Loader(),
          ),
        ),
      );
    } else {
      if (_purchaserInfo!.entitlements.all.isNotEmpty && _purchaserInfo!.entitlements.active.isNotEmpty) {
        appData.isPro = true;
      } else {
        appData.isPro = false;
      }
      if (appData.isPro!) {
        return ProScreen();
      } else {
        return UpsellScreen(
          offerings: _offerings,
        );
      }
    }
  }
}

class UpsellScreen extends StatefulWidget {
  final Offerings? offerings;

  const UpsellScreen({Key? key, required this.offerings}) : super(key: key);

  @override
  _UpsellScreenState createState() => _UpsellScreenState();
}

Future<bool> onWillPop() async {
  if (navStack.length > 1) navStack.removeLast();
  logger.d(navStack.toString());
  return true;
}

class _UpsellScreenState extends State<UpsellScreen> {
  final ScrollController _scrollController = ScrollController();
  Package? selectedPackage;
  List<Widget> features = [
    const SizedBox(
      width: 30,
    ),
    const FeatureChip(icon: JamIcons.picture, text: "Exclusive wallpapers"),
    const FeatureChip(icon: JamIcons.picture, text: "Upload unlimited walls"),
    const FeatureChip(icon: JamIcons.instant_picture, text: "No restrictions on setups"),
    const FeatureChip(icon: JamIcons.trophy, text: "Premium only giveaways"),
    const FeatureChip(icon: JamIcons.filter, text: "Apply filters on walls"),
    const FeatureChip(icon: JamIcons.user, text: "Unique PRO badge on your profile"),
    const FeatureChip(icon: JamIcons.upload, text: "Faster upload reviews"),
    const FeatureChip(icon: JamIcons.stop_sign, text: "Remove Ads"),
    const FeatureChip(icon: JamIcons.coffee_cup, text: "Support development, and content growth"),
  ];

  void _scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 6000), curve: Curves.linear);
  }

  @override
  void initState() {
    if (widget.offerings != null &&
        widget.offerings!.current != null &&
        widget.offerings!.current!.availablePackages.isNotEmpty) {
      selectedPackage = widget.offerings!.current!.availablePackages.first;
    }
    for (var i = 0; i < 100; i++) {
      features.addAll(const [
        FeatureChip(icon: JamIcons.picture, text: "Exclusive wallpapers"),
        FeatureChip(icon: JamIcons.picture, text: "Upload unlimited walls"),
        FeatureChip(icon: JamIcons.instant_picture, text: "No restrictions on setups"),
        FeatureChip(icon: JamIcons.trophy, text: "Premium only giveaways"),
        FeatureChip(icon: JamIcons.filter, text: "Apply filters on walls"),
        FeatureChip(icon: JamIcons.user, text: "Unique PRO badge on your profile"),
        FeatureChip(icon: JamIcons.upload, text: "Faster upload reviews"),
        FeatureChip(icon: JamIcons.stop_sign, text: "Remove Ads"),
        FeatureChip(icon: JamIcons.coffee_cup, text: "Support development, and content growth"),
      ]);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    if (widget.offerings != null) {
      final offering = widget.offerings!.current!.availablePackages;
      print(offering.length);
      if (offering.isNotEmpty) {
        final lifetime = offering;

        return WillPopScope(
          onWillPop: onWillPop,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: [Theme.of(context).errorColor, Theme.of(context).primaryColor],
                  stops: const [0.1, 0.6]),
            ),
            child: SafeArea(
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - (globals.notchSize ?? 24),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(
                                height: 16,
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  SizedBox(width: 40, height: 40, child: Image.asset("assets/images/prism.png")),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    // width: MediaQuery.of(context).size.width * 0.8,
                                    child: Text(
                                      "Premium",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    child: Text(
                                      "Unlock everything",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5!
                                          .copyWith(color: const Color(0xfff0f0f0)),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                width: MediaQuery.of(context).size.width,
                                height: 58,
                                child: GestureDetector(
                                  onTap: _scrollToBottom,
                                  child: ListView(
                                    controller: _scrollController,
                                    scrollDirection: Axis.horizontal,
                                    children: features,
                                  ),
                                ),
                              ),
                              Wrap(
                                children: lifetime
                                    .map(
                                      (e) => GestureDetector(
                                        onTap: () {
                                          print(e);
                                          setState(() {
                                            selectedPackage = e;
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(vertical: 8),
                                          width: MediaQuery.of(context).size.width * 0.8,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: selectedPackage == null
                                                      ? Colors.transparent
                                                      : e.identifier == selectedPackage!.identifier
                                                          ? Theme.of(context).accentColor
                                                          : Colors.transparent,
                                                  width: 4),
                                              color: const Color(0x15ffffff),
                                              borderRadius: BorderRadius.circular(10)),
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          child: Row(
                                            children: [
                                              const Spacer(),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    e.storeProduct.title
                                                        .replaceAll(" (com.slv.wall.wallpaper (unreviewed))", ""),
                                                    style: Theme.of(context).textTheme.headline3!.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color: Theme.of(context).accentColor),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    'limited access',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6!
                                                        .copyWith(color: Colors.red),
                                                    textAlign: TextAlign.center,
                                                  )
                                                ],
                                              ),
                                              const Spacer(flex: 4),
                                              Text(
                                                e.storeProduct.priceString,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3!
                                                    .copyWith(color: Theme.of(context).accentColor),
                                                textAlign: TextAlign.center,
                                              ),
                                              const Spacer(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              selectedPackage != null
                                  ? PurchaseButton(package: selectedPackage!)
                                  : SizedBox(
                                      child: Text(
                                        "Select a subscription to continue",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(fontSize: 12, color: Theme.of(context).accentColor),
                                      ),
                                    ),
                              Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: GestureDetector(
                                  // ignore: void_checks
                                  onTap: () async {
                                    try {
                                      logger.d('now trying to restore');
                                      final CustomerInfo restoredInfo = await Purchases.restorePurchases();
                                      logger.d('restore completed');
                                      logger.d(restoredInfo.toString());

                                      appData.isPro = restoredInfo.entitlements.active.isNotEmpty;

                                      logger.d('is user pro? ${appData.isPro}');

                                      if (appData.isPro!) {
                                        globals.prismUser.premium = appData.isPro!;
                                        main.prefs.put(main.userHiveKey, globals.prismUser);
                                        toasts.codeSend("You are now a premium member.");
                                        main.RestartWidget.restartApp(context);
                                      } else {
                                        toasts.error("There was an error. Please try again later.");
                                      }
                                    } on PlatformException catch (e) {
                                      logger.d('----xx-----');
                                      final errorCode = PurchasesErrorHelper.getErrorCode(e);
                                      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
                                        toasts.error("User cancelled purchase.");
                                      } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
                                        toasts.error("User not allowed to purchase.");
                                      } else {
                                        toasts.error(e.toString());
                                      }
                                    }
                                    // return UpgradeScreen();
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).errorColor == Colors.black
                                            ? Theme.of(context).accentColor.withOpacity(0.1)
                                            : Theme.of(context).accentColor,
                                        borderRadius: BorderRadius.circular(500)),
                                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                                    child: Text(
                                      'Restore',
                                      style: Theme.of(context).textTheme.headline3!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).errorColor == Colors.black
                                              ? Colors.white
                                              : Theme.of(context).primaryColor),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Text(
                                  "By purchasing this product you will be able to access the Walls premium functionalities on all the devices logged into your Google account.",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(fontSize: 12, color: Theme.of(context).accentColor),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          ),
        );
      }
    } else {
      return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Center(
            child: Loader(),
          ),
        ),
      );
    }
    return Container();
  }
}

class PurchaseButton extends StatefulWidget {
  final Package package;

  const PurchaseButton({Key? key, required this.package}) : super(key: key);

  @override
  _PurchaseButtonState createState() => _PurchaseButtonState();
}

class _PurchaseButtonState extends State<PurchaseButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: GestureDetector(
        // ignore: void_checks
        onTap: () async {
          try {
            logger.d('now trying to purchase');
            _purchaserInfo = await Purchases.purchasePackage(widget.package);
            logger.d('purchase completed');

            appData.isPro = _purchaserInfo!.entitlements.active.isNotEmpty;
            globals.prismUser.premium = appData.isPro!;
            main.prefs.put(main.userHiveKey, globals.prismUser);
            logger.d('is user pro? ${appData.isPro}');

            if (appData.isPro!) {
              toasts.codeSend("You are now a premium member.");
              main.RestartWidget.restartApp(context);
            } else {
              toasts.error("There was an error, please try again later.");
            }
          } on PlatformException catch (e) {
            logger.d('----xx-----');
            final errorCode = PurchasesErrorHelper.getErrorCode(e);
            if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
              toasts.error("User cancelled purchase.");
            } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
              toasts.error("User not allowed to purchase.");
            } else {
              toasts.error(e.toString());
              print(e.toString());
            }
          }
          // return UpgradeScreen();
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
              color: Theme.of(context).errorColor == Colors.black
                  ? Theme.of(context).accentColor
                  : Theme.of(context).errorColor,
              borderRadius: BorderRadius.circular(500)),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'Purchase',
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class ProScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Icon(
                    Icons.star,
                    color: Theme.of(context).errorColor,
                    size: 44.0,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      "You are a Prism Premium user.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      "You can use the app in all its functionality.\n\nPlease contact us at suport-walls@gmail.com if you have any problem.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ).copyWith(fontSize: 14),
                    )),
              ],
            ),
          )),
    );
  }
}

class FeatureChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const FeatureChip({
    required this.icon,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 8, 10),
      child: ActionChip(
          backgroundColor: Theme.of(context).errorColor.withOpacity(0.3),
          labelPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          avatar: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8.0),
            child: Icon(
              icon,
              size: 22,
              color: Theme.of(context).accentColor,
            ),
          ),
          label: Text(
            " $text",
            style: Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).accentColor),
          ),
          onPressed: () {}),
    );
  }
}
