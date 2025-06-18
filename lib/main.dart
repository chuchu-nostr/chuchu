import 'dart:io';

import 'package:chuchu/presentation/home/pages/home_page.dart';
import 'package:chuchu/presentation/splash/splash_page.dart';
import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:flutter/material.dart';

import 'core/account/account.dart';
import 'core/account/model/userDB_isar.dart';
import 'core/feed/feed.dart';
import 'core/manager/chuchu_user_info_manager.dart';
import 'core/manager/thread_pool_manager.dart';
import 'core/utils/app_initializer.dart';
import 'core/utils/navigator/navigator.dart';
import 'core/widgets/chuchu_Loading.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = ChuChuHttpOverrides();
  DartPingIOS.register();
  ChuChuLoading.init();

  runApp(MainApp());
}
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return MainState();
  }
}


class MainState extends State<MainApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    ThreadPoolManager.sharedInstance.initialize();
    // _nescLogin();

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: ChuChuLoading.init(),
      navigatorKey: ChuChuNavigator.navigatorKey,
      title: '',
      theme: AppTheme.whiteBackgroundTheme,
      darkTheme: AppTheme.whiteBackgroundTheme,
      themeMode: ThemeMode.light,
      home: const SplashPage(),
    );
  }
}
