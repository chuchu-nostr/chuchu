import 'dart:io';
import 'package:flutter_socks_proxy/socks_proxy.dart';
import 'unified_proxy_manager.dart';
import 'proxy_settings.dart';

class ChuCHuHttpOverrides extends HttpOverrides {
  ChuCHuHttpOverrides() {
    print('ChuCHuHttpOverrides initialized');
  }

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = createProxyHttpClient(context: context);
    
    client.badCertificateCallback = (X509Certificate cert, String host, int port) {
      return true; // Accept all certificates for development
    };

    return client;
  }

  @override
  String findProxyFromEnvironment(Uri uri, Map<String, String>? environment) {
    try {
      final settings = UnifiedProxyManager().proxySettings;
      if (settings == null || !settings.turnOnProxy) {
        return 'DIRECT';
      }

      bool onionURI = uri.host.contains(".onion");
      bool isLocalIP = _isLocalIP(uri.host);
      bool isPrivateIP = _isPrivateIP(uri.host);
      
      if (isLocalIP || isPrivateIP) {
        return 'DIRECT';
      }
      
      if (onionURI) {
        if (settings.onionHostOption == EOnionHostOption.no) {
          return 'DIRECT';
        } else {
          return 'PROXY ${settings.socksProxyHost}:${settings.socksProxyPort}';
        }
      }

      return 'PROXY ${settings.socksProxyHost}:${settings.socksProxyPort}';
    } catch (e) {
      return 'DIRECT';
    }
  }

  bool _isLocalIP(String host) {
    return host == 'localhost' || 
           host == '127.0.0.1' || 
           host == '::1' ||
           host.startsWith('192.168.') ||
           host.startsWith('10.') ||
           host.startsWith('172.') ||
           host.startsWith('169.254.');
  }

  bool _isPrivateIP(String host) {
    try {
      final parts = host.split('.');
      if (parts.length != 4) return false;
      
      final first = int.parse(parts[0]);
      final second = int.parse(parts[1]);
      
      return (first == 10) ||
             (first == 172 && second >= 16 && second <= 31) ||
             (first == 192 && second == 168) ||
             (first == 169 && second == 254);
    } catch (e) {
      return false;
    }
  }
}
