import 'package:wallpaper/main.dart' as main;
import 'package:wallpaper/routes/routes_constans.dart';
import 'package:wallpaper/themes/jam_icons_icons.dart';

import 'package:flutter/material.dart';
import 'package:wallpaper/global/globals.dart' as globals;
import 'package:wallpaper/popup/signInPopUp.dart';

class PremiumList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (globals.prismUser.premium == true)
          Container()
        else
          ListTile(
            onTap: () {
              if (globals.prismUser.loggedIn == false) {
                googleSignInPopUp(context, () {
                  if (globals.prismUser.premium == true) {
                    main.RestartWidget.restartApp(context);
                  } else {
                    Navigator.pushNamed(context, premiumRoute);
                  }
                });
              } else {
                Navigator.pushNamed(context, premiumRoute);
              }
            },
            leading: const Icon(JamIcons.instant_picture_f),
            title: Text(
              "Buy Premium",
              style: TextStyle(
                  color: Theme.of(context).accentColor, fontWeight: FontWeight.w500, fontFamily: "Proxima Nova"),
            ),
            subtitle: const Text(
              "Get unlimited setups and filters.",
              style: TextStyle(fontSize: 12),
            ),
          ),
      ],
    );
  }
}
