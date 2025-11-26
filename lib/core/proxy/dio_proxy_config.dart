import 'package:dio/dio.dart';
import 'unified_proxy_manager.dart';

class DioProxyConfig {
  static final DioProxyConfig _instance = DioProxyConfig._internal();
  factory DioProxyConfig() => _instance;
  DioProxyConfig._internal();

  bool get isProxyEnabled => UnifiedProxyManager().isEnabled;
  String get getProxyHost => UnifiedProxyManager().proxyHost;
  int get getProxyPort => UnifiedProxyManager().proxyPort;

  void configureDio(Dio dio) {
    if (!isProxyEnabled) return;

    try {
      // Dio automatically uses HttpOverrides.global for proxy
    } catch (e) {
      // Ignore configuration errors
    }
  }

  Map<String, dynamic> getProxyConfig() {
    if (!isProxyEnabled) return {};

    return {
      'proxy': 'http://${getProxyHost}:${getProxyPort}',
      'proxyHost': getProxyHost,
      'proxyPort': getProxyPort,
    };
  }

  void printCurrentConfig() {
    if (isProxyEnabled) {
      print('Dio Proxy: $getProxyHost:$getProxyPort');
    }
  }
}
