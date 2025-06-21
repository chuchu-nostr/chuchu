import 'dart:io';
import 'package:flutter_socks_proxy/socks_proxy.dart';
import '../config/config.dart';

class ChuChuHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = createProxyHttpClient(context: context)
      ..findProxy = (Uri uri) {
        ProxySettings? settings = Config.sharedInstance.proxySettings;
        if (settings == null || !settings.turnOnProxy) {
          return 'DIRECT';
        }
        
        if (settings.turnOnProxy) {
          bool onionURI = uri.host.contains(".onion");
          switch (settings.onionHostOption) {
            case EOnionHostOption.no:
              return onionURI ? '' : 'SOCKS5 ${settings.socksProxyHost}:${settings.socksProxyPort}';
            case EOnionHostOption.whenAvailable:
              return !onionURI
                  ? 'DIRECT'
                  : 'SOCKS5 ${settings.socksProxyHost}:${settings.socksProxyPort}';
            case EOnionHostOption.required:
              return !onionURI ? '' : 'SOCKS5 ${settings.socksProxyHost}:${settings.socksProxyPort}';
            default:
              break;
          }
        }
        return "DIRECT";
      }
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
    return client;
  }
}


