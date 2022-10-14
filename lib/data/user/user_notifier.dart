
import 'package:flutter/material.dart';
import 'package:wallpaper/auth/userModel.dart';
import 'package:wallpaper/data/user/user_service.dart';
import 'package:wallpaper/locator/locator.dart';

class UserNotifier with ChangeNotifier {
  final _userService = locator<UserService>();

  Stream<List<WallUsersV2>> get sessionsStream => _userService.sessionsStream;

  UserDiscoveryState? get state =>
      _userService.userDiscoveryStateStream.valueOrNull;

  UserNotifier() {
    _userService.userDiscoveryStateStream.listen((event) {
      notifyListeners();
    });
  }
}
