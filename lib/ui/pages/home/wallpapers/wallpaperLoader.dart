
import 'package:flutter/material.dart';

import 'package:wallpaper/logger/logger.dart';
import 'package:wallpaper/ui/pages/home/wallpapers/loading.dart';
import 'package:wallpaper/ui/pages/home/wallpapers/wallpaperGrid.dart';

class WallpaperLoader extends StatefulWidget {
  final Future future;
  final String provider;
  const WallpaperLoader({required this.future, required this.provider});
  @override
  _WallpaperLoaderState createState() => _WallpaperLoaderState();
}

class _WallpaperLoaderState extends State<WallpaperLoader> {
  Future? _future;

  @override
  void initState() {
    _future = widget.future;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (ctx, snapshot) {
        if (snapshot == null) {
          logger.d("snapshot null");
          return const LoadingCards();
        }
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.none) {
          logger.d("snapshot none, waiting");
          return const LoadingCards();
        } else {
          return WallpaperGrid(
            provider: widget.provider,
          );
        }
      },
    );
  }
}
