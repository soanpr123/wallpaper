
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/global/globals.dart' as globals;
import 'package:wallpaper/analytichs/analytics_service.dart';
import 'package:wallpaper/data/categories/pexels/model/wallpaperp.dart';
import 'package:wallpaper/data/favourites/provider/favouriteProvider.dart';
import 'package:wallpaper/data/wallhaven/model/wallpaper.dart';
import 'package:wallpaper/popup/signInPopUp.dart';
import 'package:wallpaper/ui/animated/favouriteIcon.dart';

class FavIconButton extends StatefulWidget {
  final String? id;
  final Map? prism;
  const FavIconButton({
    required this.id,
    this.prism,
    Key? key,
  }) : super(key: key);

  @override
  _FavIconButtonState createState() => _FavIconButtonState();
}

class _FavIconButtonState extends State<FavIconButton> {
  late Box box;

  @override
  void initState() {
    box = Hive.box('localFav');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FavoriteIcon(
          valueChanged: () {
            if (globals.prismUser.loggedIn == false) {
              googleSignInPopUp(context, () {
                onFav(widget.id, "Prism", null, null, widget.prism);
              });
            } else {
              onFav(widget.id, "Prism", null, null, widget.prism);
            }
          },
          iconColor: Theme.of(context).accentColor,
          iconSize: 30,
          isFavorite: box.get(widget.id, defaultValue: false) as bool,
        ),
      ],
    );
  }

  Future<void> onFav(String? id, String provider, WallPaper? wallhaven,
      WallPaperP? pexels, Map? prism) async {
    setState(() {});
    Provider.of<FavouriteProvider>(context, listen: false)
        .favCheck(id, provider, wallhaven, pexels, prism)
        .then((value) {
      analytics.logEvent(
          name: 'fav_status_changed',
          parameters: {'id': id, 'provider': provider});
      setState(() {});
    });
  }
}
