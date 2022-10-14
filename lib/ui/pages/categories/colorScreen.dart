import 'package:wallpaper/data/categories/pexels/provider/pexelsWithoutProvider.dart' as PData;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:wallpaper/logger/logger.dart';
import 'package:wallpaper/routes/router.dart';
import 'package:wallpaper/ui/pages/home/wallpapers/colorLoader.dart';
import 'package:wallpaper/ui/widgets/home/core/bottomNavBar.dart';
import 'package:wallpaper/ui/widgets/home/core/headingChipBar.dart';

class ColorScreen extends StatelessWidget {
  final List? arguments;
  const ColorScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        int count = 0;
        while (navStack.last == "Color") {
          navStack.removeLast();
          count++;
        }
        logger.d(navStack.toString());
        logger.d(count.toString());
        for (int i = 0; i < count; i++) {
          Navigator.pop(context);
        }
        if ((navStack.last == "Wallpaper") ||
            (navStack.last == "Search Wallpaper") ||
            (navStack.last == "SharedWallpaper") ||
            (navStack.last == "SetupView") ||
            (navStack.last == "User ProfileWallpaper")) {}
        return false;
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: const PreferredSize(
            preferredSize: Size(double.infinity, 55),
            child: HeadingChipBar(
              current: "Colors",
            ),
          ),
          body: BottomBar(
            child: ColorLoader(
              future: PData.getWallsPbyColor("color: ${arguments![0]}"),
              provider: "Colors - color: ${arguments![0]}",
            ),
          )),
    );
  }
}
