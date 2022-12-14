import 'package:flutter/material.dart';

import 'package:wallpaper/logger/logger.dart';
import 'package:wallpaper/routes/router.dart';
import 'package:wallpaper/themes/jam_icons_icons.dart';

class HeadingChipBar extends StatefulWidget {
  final String current;
  const HeadingChipBar({Key? key, required this.current}) : super(key: key);

  @override
  _HeadingChipBarState createState() => _HeadingChipBarState();
}

class _HeadingChipBarState extends State<HeadingChipBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: IconButton(
          icon: Icon(JamIcons.chevron_left, color: Theme.of(context).accentColor),
          onPressed: () {
            Navigator.pop(context);
            if (navStack.length > 1) {
              navStack.removeLast();
              if ((navStack.last == "Wallpaper") ||
                  (navStack.last == "Search Wallpaper") ||
                  (navStack.last == "SharedWallpaper") ||
                  (navStack.last == "SetupView")) {}
            }
            logger.d(navStack.toString());
          }),
      title: Text(
        widget.current,
        style: Theme.of(context).textTheme.headline3!.copyWith(color: Theme.of(context).accentColor),
      ),
    );
  }
}
