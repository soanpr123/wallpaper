import 'dart:io';

import 'package:animations/animations.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper/logger/logger.dart';

import 'package:wallpaper/routes/routes_constans.dart';
import 'package:wallpaper/themes/jam_icons_icons.dart';

class DownloadList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        leading: const Icon(
          JamIcons.download,
        ),
        title: Text(
          "Downloads",
          style:
              TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.w500, fontFamily: "Proxima Nova"),
        ),
        subtitle: Text(
          "View or clear downloads",
          style: TextStyle(fontSize: 12, color: Theme.of(context).accentColor),
        ),
        children: [
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, downloadRoute);
            },
            leading: const Icon(JamIcons.download),
            title: Text(
              "My Downloads",
              style: TextStyle(
                  color: Theme.of(context).accentColor, fontWeight: FontWeight.w500, fontFamily: "Proxima Nova"),
            ),
            subtitle: const Text(
              "See all your downloaded wallpapers",
              style: TextStyle(fontSize: 12),
            ),
            trailing: const Icon(JamIcons.chevron_right),
          ),
        ]);
  }
}
