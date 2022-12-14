import 'package:wallpaper/data/categories/pexels/provider/pexelsWithoutProvider.dart' as PData;

import 'package:flutter/material.dart';

import 'package:wallpaper/logger/logger.dart';
import 'package:wallpaper/ui/pages/home/wallpapers/colorGrid.dart';
import 'package:wallpaper/ui/pages/home/wallpapers/loading.dart';

class ColorLoader extends StatefulWidget {
  final Future future;
  final String provider;
  const ColorLoader({required this.future, required this.provider});
  @override
  _ColorLoaderState createState() => _ColorLoaderState();
}

class _ColorLoaderState extends State<ColorLoader> {
  Future? _future;

  @override
  void initState() {
    PData.wallsC = [];
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
        if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
          logger.d("snapshot none, waiting");
          return const LoadingCards();
        } else {
          return ColorGrid(
            provider: widget.provider,
          );
        }
      },
    );
  }
}
