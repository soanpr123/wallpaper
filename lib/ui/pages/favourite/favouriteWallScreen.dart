import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'package:wallpaper/data/favourites/provider/favouriteProvider.dart';
import 'package:wallpaper/logger/logger.dart';
import 'package:wallpaper/routes/router.dart';
import 'package:wallpaper/ui/widgets/favourite/favLoader.dart';
import 'package:wallpaper/ui/widgets/home/core/bottomNavBar.dart';
import 'package:wallpaper/ui/widgets/home/core/headingChipBar.dart';

class FavouriteWallpaperScreen extends StatelessWidget {
  const FavouriteWallpaperScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (navStack.length > 1) navStack.removeLast();
        logger.d(navStack.toString());
        return true;
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: const PreferredSize(
            preferredSize: Size(double.infinity, 55),
            child: HeadingChipBar(
              current: "Favourites",
            ),
          ),
          body: BottomBar(
            child: FavLoader(
              future: Provider.of<FavouriteProvider>(context, listen: false).getDataBase(),
            ),
          )),
    );
  }
}
