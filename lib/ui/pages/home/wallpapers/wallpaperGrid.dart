import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/data/prism/provider/prismWithoutProvider.dart' as Data;
import 'package:wallpaper/global/globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';

import 'package:wallpaper/logger/logger.dart';
import 'package:wallpaper/popup/signInPopUp.dart';
import 'package:wallpaper/routes/routes_constans.dart';
import 'package:wallpaper/themes/themeModeProvider.dart';
import 'package:wallpaper/ui/pages/home/wallpapers/carouselDots.dart';
import 'package:wallpaper/ui/pages/home/wallpapers/seeMoreButton.dart';
import 'package:wallpaper/ui/pages/home/wallpapers/wallpaperTile.dart';
import 'package:wallpaper/ui/widgets/focussedMenu/focusedMenu.dart';
import 'package:wallpaper/ui/widgets/home/core/inheritedScrollControllerProvider.dart';
import 'package:wallpaper/ui/widgets/premiumBanners/walls.dart';
import 'package:wallpaper/ui/widgets/premiumBanners/wallsCarousel.dart';

class WallpaperGrid extends StatefulWidget {
  final String? provider;
  const WallpaperGrid({required this.provider});
  @override
  _WallpaperGridState createState() => _WallpaperGridState();
}

class _WallpaperGridState extends State<WallpaperGrid> {
  GlobalKey<RefreshIndicatorState> refreshHomeKey = GlobalKey<RefreshIndicatorState>();
  int _current = 0;
  bool seeMoreLoader = false;
  @override
  void initState() {
    super.initState();
  }

  Future<void> refreshList() async {
    refreshHomeKey.currentState?.show();
    Data.prismWalls = [];
    Data.subPrismWalls = [];
    Data.getPrismWalls();
  }

  void showGooglePopUp(BuildContext context, Function func) {
    logger.d(globals.prismUser.loggedIn.toString());
    if (globals.prismUser.loggedIn == false) {
      googleSignInPopUp(context, func);
    } else {
      func();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController? controller = InheritedDataProvider.of(context)!.scrollController;
    final CarouselController carouselController = CarouselController();
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: NestedScrollView(
        controller: controller,
        headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
          SliverAppBar(
            primary: false,
            backgroundColor: Theme.of(context).primaryColor,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            expandedHeight: 200,
            flexibleSpace: SizedBox(
              child: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: <Widget>[
                  CarouselSlider.builder(
                    carouselController: carouselController,
                    itemCount: Data.subPrismWalls == null && Data.subPrismWalls!.isEmpty
                        ? 4
                        : Data.subPrismWalls!.take(5).length,
                    options: CarouselOptions(
                        height: 200,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        onPageChanged: (index, reason) {
                          if (mounted) {
                            setState(() {
                              _current = index;
                            });
                          }
                        }),
                    itemBuilder: (BuildContext context, int i, int rI) => Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.fromLTRB(3, 1, 3, 6),
                      child: GestureDetector(
                        onTap: () {
                          if (Data.subPrismWalls == []) {
                          } else {
                            globals.isPremiumWall(globals.premiumCollections,
                                            Data.subPrismWalls![i]["collections"] as List? ?? []) ==
                                        true &&
                                    globals.prismUser.premium != true
                                ? showGooglePopUp(context, () {
                                    Navigator.pushNamed(
                                      context,
                                      premiumRoute,
                                    );
                                  })
                                : Navigator.pushNamed(context, wallpaperRoute, arguments: [
                                    widget.provider,
                                    i,
                                    Data.subPrismWalls![i]["wallpaper_thumb"],
                                  ]);
                          }
                        },
                        child: Data.subPrismWalls!.isEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Provider.of<ThemeModeExtended>(context)
                                              .getCurrentModeStyle(MediaQuery.of(context).platformBrightness) ==
                                          "Dark"
                                      ? Colors.white10
                                      : Colors.black.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              )
                            : PremiumBannerWallsCarousel(
                                comparator: !globals.isPremiumWall(
                                    globals.premiumCollections, Data.subPrismWalls![i]["collections"] as List? ?? []),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Provider.of<ThemeModeExtended>(context)
                                                  .getCurrentModeStyle(MediaQuery.of(context).platformBrightness) ==
                                              "Dark"
                                          ? Colors.white10
                                          : Colors.black.withOpacity(.1),
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              Data.subPrismWalls![i]["wallpaper_thumb"].toString()),
                                          fit: BoxFit.cover)),
                                  child: Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      color: Colors.transparent,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "",
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2!
                                              .copyWith(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                  CarouselDots(current: _current),
                ],
              ),
            ),
          ),
        ],
        body: RefreshIndicator(
          backgroundColor: Theme.of(context).primaryColor,
          key: refreshHomeKey,
          onRefresh: refreshList,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                if (!seeMoreLoader) {
                  setState(() {
                    seeMoreLoader = true;
                  });
                  Data.seeMorePrism();
                  setState(() {
                    Future.delayed(const Duration(seconds: 1)).then((value) => seeMoreLoader = false);
                  });
                }
              }
              return false;
            },
            child: GridView.builder(
              physics: const ScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 4),
              itemCount: Data.subPrismWalls!.isEmpty ? 20 : Data.subPrismWalls!.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: MediaQuery.of(context).orientation == Orientation.portrait ? 300 : 250,
                  childAspectRatio: 0.6625,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8),
              itemBuilder: (context, index) {
                if (index == Data.subPrismWalls!.length - 1) {
                  return SeeMoreButton(
                    seeMoreLoader: seeMoreLoader,
                    func: () {
                      if (!seeMoreLoader) {
                        setState(() {
                          seeMoreLoader = true;
                        });
                        Data.seeMorePrism();
                        setState(() {
                          Future.delayed(const Duration(seconds: 1)).then((value) => seeMoreLoader = false);
                        });
                      }
                    },
                  );
                }
                return globals.prismUser.premium == true
                    ? FocusedMenuHolder(
                        provider: widget.provider,
                        index: index,
                        child: WallpaperTile(widget: widget, index: index),
                      )
                    : PremiumBannerWalls(
                        comparator: !globals.isPremiumWall(
                            globals.premiumCollections,
                            Data.subPrismWalls!.isEmpty
                                ? []
                                : Data.subPrismWalls![index]["collections"] as List? ?? []),
                        defaultChild: FocusedMenuHolder(
                          provider: widget.provider,
                          index: index,
                          child: WallpaperTile(widget: widget, index: index),
                        ),
                        trueChild: WallpaperTile(widget: widget, index: index),
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
