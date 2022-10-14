
import 'package:flutter/material.dart';
import 'package:wallpaper/analytichs/analytics_service.dart';
import 'package:wallpaper/data/collections/provider/collectionsWithoutProvider.dart';


import 'package:wallpaper/logger/logger.dart';
import 'package:wallpaper/routes/router.dart';
import 'package:wallpaper/ui/animated/loader.dart';
import 'package:wallpaper/ui/widgets/collections/collectionsGrid.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  Future<bool> onWillPop() async {
    if (navStack.length > 1) navStack.removeLast();
    logger.d(navStack.toString());
    return true;
  }

  @override
  void initState() {
    analytics.logEvent(
      name: 'collections_checked',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: FutureBuilder<List?>(
        future: getCollections(), // async work
        builder: (BuildContext context, AsyncSnapshot<List?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: Loader());
            case ConnectionState.none:
              return Center(child: Loader());
            default:
              if (snapshot.hasError) {
                return RefreshIndicator(
                    onRefresh: () async {
                      getCollections();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Spacer(),
                        Center(child: Text("Can't connect to the Servers!")),
                        Spacer(),
                      ],
                    ));
              } else {
                return CollectionsGrid();
              }
          }
        },
      ),
    );
  }
}
