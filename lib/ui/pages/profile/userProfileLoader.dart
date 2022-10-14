import 'package:wallpaper/data/profile/wallpaper/getUserProfile.dart';
import 'package:wallpaper/ui/pages/profile/userProfileGrid.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/logger/logger.dart';
import 'package:wallpaper/data/profile/wallpaper/getUserProfile.dart';
import 'package:wallpaper/ui/pages/home/wallpapers/loading.dart';

class UserProfileLoader extends StatefulWidget {
  final String? email;
  const UserProfileLoader({required this.email});
  @override
  _UserProfileLoaderState createState() => _UserProfileLoaderState();
}

class _UserProfileLoaderState extends State<UserProfileLoader> {
  Future? _future;

  @override
  void initState() {
    _future = Provider.of<UserProfileProvider>(context, listen: false)
        .getuserProfileWalls(widget.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: FutureBuilder(
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
            return UserProfileGrid(
              email: widget.email,
            );
          }
        },
      ),
    );
  }
}
