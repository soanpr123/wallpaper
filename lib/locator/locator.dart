import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wallpaper/data/user/user_notifier.dart';
import 'package:wallpaper/data/user/user_service.dart';
import 'package:wallpaper/logger/logger.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Stopwatch stopwatch = Stopwatch()..start();
  locator.registerLazySingleton<UserService>(() => UserService());
  locator.registerFactory<UserNotifier>(() => UserNotifier());
  logger.d('SETUP LOCATOR EXECUTED IN ${stopwatch.elapsed}');
  stopwatch.stop();
}
