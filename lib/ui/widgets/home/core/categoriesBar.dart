import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallpaper/analytichs/analytics_service.dart';
import 'package:wallpaper/global/categoryProvider.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:wallpaper/global/globals.dart' as globals;
import 'package:wallpaper/global/svgAssets.dart';
import 'package:wallpaper/main.dart' as main;
import 'package:wallpaper/logger/logger.dart';
import 'package:wallpaper/popup/categoryPopUp.dart';
import 'package:wallpaper/themes/jam_icons_icons.dart';

class CategoriesBar extends StatefulWidget {
  const CategoriesBar({
    Key? key,
  }) : super(key: key);

  @override
  _CategoriesBarState createState() => _CategoriesBarState();
}

class _CategoriesBarState extends State<CategoriesBar> {
  bool noNotification = true;
  // final Box<InAppNotif> box = Hive.box('inAppNotifs');
  List notifications = [];
  final key = GlobalKey();
  @override
  void initState() {
    if (main.prefs.get("Subscriber", defaultValue: true) as bool) {
      fetchNotifications();
    } else {
      noNotification = true;
    }
    super.initState();
    checkForUpdate();
  }

  Future<void> fetchNotifications() async {
    setState(() {
      // notifications = box.values.toList();
    });
    checkNewNotification();
  }

  void checkNewNotification() {
    // final Box<InAppNotif> box = Hive.box('inAppNotifs');
    // notifications = box.values.toList();
    notifications.removeWhere((element) => element.read == true);
    if (notifications.isEmpty) {
      setState(() {
        noNotification = true;
      });
    } else {
      setState(() {
        noNotification = false;
      });
    }
  }

  //Check for update if available
  Future<void> checkForUpdate() async {
    // InAppUpdate.checkForUpdate().then((info) {
    //   if (info.updateAvailability == UpdateAvailability.updateAvailable) {
    //     InAppUpdate.performImmediateUpdate().catchError((e) => _showError(e));
    //   }
    // }).catchError((e) {
    //   _showError(e);
    // });
  }

  void _showError(dynamic exception) {
    logger.d(exception.toString());
  }

  @override
  Widget build(BuildContext context) {
    if (!globals.tooltipShown) {
      Future.delayed(const Duration(seconds: 2)).then((_) {
        try {
          final dynamic tooltip = key.currentState;
          if (!noNotification && notifications.isNotEmpty) {
            tooltip.ensureTooltipVisible();
            globals.tooltipShown = true;
          }
          if (!noNotification && notifications.isNotEmpty) {
            Future.delayed(const Duration(seconds: 5)).then((_) {
              tooltip.deactivate();
            });
          }
        } catch (e) {
          logger.d(e.toString());
        }
      });
    }
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      titleSpacing: 0,
      centerTitle: true,
      leading: Container(),
      title: Align(
        child: SizedBox(
          height: 24,
          width: 260,
          child: GestureDetector(
            onTap: () {
              analytics.logEvent(
                name: 'categories_checked',
              );
              showCategories(context, Provider.of<CategorySupplier>(context, listen: false).selectedChoice);
            },
            child: Text(
              Provider.of<CategorySupplier>(context).getCurrentChoice!.toUpperCase(),
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              style: Theme.of(context).textTheme.headline3!.copyWith(
                    fontFamily: "Proxima Nova",
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).accentColor,
                  ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            JamIcons.grid,
            color: Theme.of(context).accentColor,
          ),
          onPressed: () {
            analytics.logEvent(
              name: 'categories_checked',
            );
            showCategories(context, Provider.of<CategorySupplier>(context, listen: false).selectedChoice);
          },
          tooltip: 'Categories',
        )
      ],
    );
  }
}
