import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dart_ping_ios/dart_ping_ios.dart';

import '../manager/chuchu_user_info_manager.dart';
import '../manager/thread_pool_manager.dart';
import '../widgets/chuchu_Loading.dart';
import 'app_initializer.dart';


class InitializationManager {
  static final InitializationManager _instance = InitializationManager._internal();
  factory InitializationManager() => _instance;
  InitializationManager._internal();

  static InitializationManager get instance => _instance;

  bool _isInitialized = false;
  final List<String> _errors = [];
  final Map<String, bool> _initializationStatus = {};


  bool get isInitialized => _isInitialized;


  List<String> get errors => List.unmodifiable(_errors);


  Map<String, bool> get initializationStatus => Map.unmodifiable(_initializationStatus);


  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }
    try {
      await _initializeCore();
      await _initializeBasicServices();

      _initializePlatformSpecificAsync();
      _initializeUserServicesAsync();
      _initializeBackgroundServicesAsync();
      
      _isInitialized = true;

      
    } catch (error, stackTrace) {
      final errorMessage = 'init fail: $error';
      _errors.add(errorMessage);
      debugPrint(errorMessage);
      debugPrint('stackTrace: $stackTrace');
      
      _isInitialized = true;
      rethrow;
    }
  }

  Future<void> _initializeCore() async {
    await _executeWithStatus('core_systems', () async {
      HttpOverrides.global = ChuChuHttpOverrides();
      ChuChuLoading.init();
    });
  }

  Future<void> _initializeBasicServices() async {
    await _executeWithStatus('basic_services', () async {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
        ),
      );

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      await ThreadPoolManager.sharedInstance.initialize();
    });
  }

  void _initializePlatformSpecificAsync() {
    _executeAsyncWithStatus('platform_specific', () async {
      if (Platform.isIOS) {
        DartPingIOS.register();
        debugPrint('iOS init successfully');
      } else if (Platform.isAndroid) {
        debugPrint('Android init successfully');
      }
    });
  }

  void _initializeUserServicesAsync() {
    _executeAsyncWithStatus('user_services', () async {
      await ChuChuUserInfoManager.sharedInstance.initLocalData();
    });
  }

  void _initializeBackgroundServicesAsync() {
    _executeAsyncWithStatus('background_services', () async {
    });
  }

  Future<void> _executeWithStatus(String taskName, Future<void> Function() task) async {
    try {
      await task();
      _initializationStatus[taskName] = true;
    } catch (error, stackTrace) {
      _initializationStatus[taskName] = false;
      final errorMessage = '$taskName fail: $error';
      _errors.add(errorMessage);
      debugPrint(errorMessage);
      debugPrint(': $stackTrace');
      rethrow;
    }
  }

  void _executeAsyncWithStatus(String taskName, Future<void> Function() task) {
    Future.microtask(() async {
      try {
        await task();
        _initializationStatus[taskName] = true;
      } catch (error, stackTrace) {
        _initializationStatus[taskName] = false;
        final errorMessage = '$taskName init fail: $error';
        _errors.add(errorMessage);
        debugPrint(errorMessage);
        debugPrint(': $stackTrace');
      }
    });
  }

  @visibleForTesting
  void reset() {
    _isInitialized = false;
    _errors.clear();
    _initializationStatus.clear();
  }

  Map<String, dynamic> getInitializationSummary() {
    return {
      'isInitialized': _isInitialized,
      'totalErrors': _errors.length,
      'errors': _errors,
      'componentStatus': _initializationStatus,
      'successfulComponents': _initializationStatus.values.where((status) => status).length,
      'failedComponents': _initializationStatus.values.where((status) => !status).length,
    };
  }

  Future<bool> waitForComponent(String componentName, {Duration timeout = const Duration(seconds: 10)}) async {
    final startTime = DateTime.now();
    
    while (DateTime.now().difference(startTime) < timeout) {
      if (_initializationStatus.containsKey(componentName)) {
        return _initializationStatus[componentName] ?? false;
      }
      
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    return false;
  }

  bool areKeyComponentsReady() {
    final keyComponents = ['core_systems', 'basic_services'];
    return keyComponents.every((component) => 
        _initializationStatus[component] == true);
  }
} 