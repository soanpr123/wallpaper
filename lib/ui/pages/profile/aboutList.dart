

import 'package:flutter/material.dart';
import 'package:wallpaper/routes/routes_constans.dart';
import 'package:wallpaper/themes/jam_icons_icons.dart';

class AboutList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: const Icon(JamIcons.info),
        title: Text(
          "About Prism",
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.w500,
              fontFamily: "Proxima Nova"),
        ),
        subtitle: const Text(
          "GitHub, website & more!",
          style: TextStyle(fontSize: 12),
        ),
        trailing: const Icon(JamIcons.chevron_right),
        onTap: () {
          Navigator.pushNamed(context, aboutRoute);
        });
  }
}
