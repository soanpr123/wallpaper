import 'package:flutter/material.dart';

import 'package:wallpaper/themes/jam_icons_icons.dart';

class PremiumBannerSetupPhotographer extends StatelessWidget {
  final bool? comparator;
  final Widget? child;
  const PremiumBannerSetupPhotographer({this.comparator, this.child});
  @override
  Widget build(BuildContext context) {
    return comparator!
        ? child!
        : Stack(
            children: [
              child,
              Positioned(
                top: (MediaQuery.of(context).size.width / 2) / 0.5025 - 52,
                left: MediaQuery.of(context).size.width / 2 - 53.5,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color(0xFFFFB800),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  padding: const EdgeInsets.all(0),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Icon(
                      JamIcons.star_f,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ] as List<Widget>,
          );
  }
}
