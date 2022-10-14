import 'package:wallpaper/auth/google_auth.dart';
import 'package:wallpaper/data/categories/pexels/model/wallpaperp.dart';
// import 'package:wallpaper/data/pexels/model/wallpaperp.dart';
import 'package:wallpaper/data/wallhaven/model/wallpaper.dart';
import 'package:wallpaper/logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/global/globals.dart' as globals;
import 'package:hive/hive.dart';
import 'package:wallpaper/auth/google_auth.dart';

class FavouriteProvider extends ChangeNotifier {
  final FirebaseFirestore databaseReference = FirebaseFirestore.instance;
  List? liked;
  Future<List?> getDataBase() async {
    final String uid = globals.prismUser.id;
    liked = [];
    await databaseReference.collection(USER_NEW_COLLECTION).doc(uid).collection("images").get().then((value) {
      liked = [];
      for (final f in value.docs) {
        liked!.add(f.data());
      }
      liked!.sort((a, b) {
        if (a["createdAt"] != null && b["createdAt"] != null) {
          return (a["createdAt"] as Timestamp).toDate().compareTo((b["createdAt"] as Timestamp).toDate());
        } else {
          return 0;
        }
      });
      liked = liked!.reversed.toList();
      // });
      // .catchError((e) {
      //   logger.d("data done with error");
    });

    return liked;
  }

  Future<bool> deleteDataByID(String id) async {
    final String uid = globals.prismUser.id;
    try {
      await databaseReference.collection(USER_NEW_COLLECTION).doc(uid).collection("images").doc(id).delete();
    } catch (e) {
      logger.d(e.toString());
    }
    await getDataBase();
    return true;
  }

  Future<bool> createDataByWall(String provider, WallPaper? wallhaven, WallPaperP? pexels, Map? wallpaper) async {
    final String uid = globals.prismUser.id;
    if (provider == "WallHaven") {
      await databaseReference
          .collection(USER_NEW_COLLECTION)
          .doc(uid)
          .collection("images")
          .doc(wallhaven!.id.toString())
          .set({
        "id": wallhaven.id.toString(),
        "url": wallhaven.path.toString(),
        "thumb": wallhaven.thumbs!["original"].toString(),
        "category": wallhaven.category.toString(),
        "provider": "WallHaven",
        "views": wallhaven.views.toString(),
        "resolution": wallhaven.resolution.toString(),
        "fav": wallhaven.favourites.toString(),
        "size": wallhaven.file_size.toString(),
        "photographer": "",
        "createdAt": DateTime.now().toUtc()
      });
    } else if (provider == "Pexels") {
      await databaseReference
          .collection(USER_NEW_COLLECTION)
          .doc(uid)
          .collection("images")
          .doc(pexels!.id.toString())
          .set({
        "id": pexels.id.toString(),
        "url": pexels.src!["original"].toString(),
        "thumb": pexels.src!["medium"].toString(),
        "category": "",
        "provider": "Pexels",
        "views": "",
        "resolution": "${pexels.width}x${pexels.height}",
        "fav": "",
        "size": "",
        "photographer": pexels.photographer.toString(),
        "createdAt": DateTime.now().toUtc()
      });
    } else if (provider == "wallpaper") {
      await databaseReference
          .collection(USER_NEW_COLLECTION)
          .doc(uid)
          .collection("images")
          .doc(wallpaper!["id"].toString())
          .set({
        "id": wallpaper["id"].toString(),
        "url": wallpaper["wallpaper_url"].toString(),
        "thumb": wallpaper["wallpaper_thumb"].toString(),
        "category": wallpaper["desc"].toString(),
        "provider": "wallpaper",
        "views": "",
        "resolution": wallpaper["resolution"].toString(),
        "fav": "",
        "size": wallpaper["size"].toString(),
        "photographer": wallpaper["by"].toString(),
        "createdAt": DateTime.now().toUtc()
      });
    }
    return true;
  }

  Future favCheck(String? id, String provider, WallPaper? wallhaven, WallPaperP? pexels, Map? wallpaper) async {
    int? index;
    await getDataBase().then(
      (value) {
        for (final element in value!) {
          if (element["id"] == id) {
            index = value.indexOf(element);
          }
        }
        if (index == null) {
          logger.d("Fav");
          createDataByWall(provider, wallhaven, pexels, wallpaper);
          localFavSave(provider, wallhaven, pexels, wallpaper);
        } else {
          localFavDelete(id);
          deleteDataByID(id!);
          return false;
        }
      },
    );
  }

  bool localFavSave(String provider, WallPaper? wallhaven, WallPaperP? pexels, Map? wallpaper) {
    if (provider == "WallHaven") {
      final Box box = Hive.box('localFav');
      box.put(wallhaven!.id.toString(), true);
      return true;
    } else if (provider == "Pexels") {
      final Box box = Hive.box('localFav');
      box.put(pexels!.id.toString(), true);
      return true;
    } else if (provider == "wallpaper") {
      final Box box = Hive.box('localFav');
      box.put(wallpaper!["id"].toString(), true);
      return true;
    }
    return false;
  }

  bool localFavDelete(String? id) {
    final Box box = Hive.box('localFav');
    box.delete(id);
    return true;
  }

  Future<int> countFav() async {
    int favs = 0;
    logger.d("in countfav");
    await getDataBase().then((value) {
      logger.d(value!.length.toString());
      favs = value.length;
    });
    return favs;
  }

  Future<bool> deleteData() async {
    final String uid = globals.prismUser.id;
    try {
      await databaseReference.collection(USER_NEW_COLLECTION).doc(uid).collection("images").get().then((snapshot) {
        for (final DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
    } catch (e) {
      logger.d(e.toString());
    }
    await getDataBase();
    return true;
  }
}
