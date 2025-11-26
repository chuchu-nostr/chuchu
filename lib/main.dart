
import 'package:chuchu/presentation/splash/splash_page.dart';
import 'package:flutter/material.dart';

import 'core/manager/chuchu_user_info_manager.dart';
import 'core/manager/thread_pool_manager.dart';
import 'core/utils/initialization_manager.dart';
import 'core/utils/navigator/navigator.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/chuchu_Loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await InitializationManager.instance.initialize();
  } catch (error) {
    debugPrint('The application initialization failed, but it continued to start: $error');
  }
  
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
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.resumed:
        _handleAppResumed();
        break;
      case AppLifecycleState.paused:
        _handleAppPaused();
        break;
      case AppLifecycleState.detached:
        _handleAppDetached();
        break;
      default:
        break;
    }
  }

  void _handleAppResumed() {
    Future.microtask(() async {
      try {
        final userServiceReady = await InitializationManager.instance
            .waitForComponent('user_services', timeout: const Duration(seconds: 5));
        
        if (userServiceReady) {
          await ChuChuUserInfoManager.sharedInstance.resetHeartBeat();
          debugPrint('The heart rate reset is completed.');
        } else {
          debugPrint('The user service is not ready. Skip the heartbeat reset');
        }
      } catch (error) {
        debugPrint('Heart rate reset error: $error');
      }
    });
  }

  void _handleAppPaused() {
    debugPrint('The application has been suspended.');
  }

  void _handleAppDetached() {
    Future.microtask(() async {
      try {
        ThreadPoolManager.sharedInstance.dispose();
        debugPrint('The application resource cleaning has been completed');
      } catch (error) {
        debugPrint('Application resource cleaning error: $error');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: ChuChuLoading.init(),
      navigatorKey: ChuChuNavigator.navigatorKey,
      title: 'ChuChu',
      theme: lightTheme,
      darkTheme: lightTheme,
      themeMode: ThemeMode.light,
      home: const SplashPage(),
      onGenerateRoute: (settings) {
        return null;
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const SplashPage(),
        );
      },
    );
  }
}
