// Conditional import for HttpOverrides
import 'dart:io' if (dart.library.html) 'package:chuchu/core/account/platform_stub.dart';
import 'chuchu_http_overrides.dart';
import '../config/config.dart' as config;
import 'proxy_settings.dart';

/// Unified proxy configuration manager
/// Centralizes all proxy settings and synchronizes them across all systems
class UnifiedProxyManager {
  static final UnifiedProxyManager _instance = UnifiedProxyManager._internal();
  factory UnifiedProxyManager() => _instance;
  UnifiedProxyManager._internal();

  // Default proxy configuration
  static const String _defaultHost = '127.0.0.1';
  static const int _defaultPort = 7890;

  // Current proxy settings
  ProxySettings _proxySettings = ProxySettings(
    turnOnProxy: false,
    socksProxyHost: _defaultHost,
    socksProxyPort: _defaultPort,
    onionHostOption: EOnionHostOption.whenAvailable,
  );

  // Getters
  ProxySettings get proxySettings => _proxySettings;
  String get proxyHost => _proxySettings.socksProxyHost;
  int get proxyPort => _proxySettings.socksProxyPort;
  bool get isEnabled => _proxySettings.turnOnProxy;

  Future<void> initialize() async {
    try {
      final existingSettings = config.Config.sharedInstance.proxySettings;
      if (existingSettings != null && existingSettings.turnOnProxy) {
        _proxySettings = ProxySettings(
          turnOnProxy: existingSettings.turnOnProxy,
          socksProxyHost: existingSettings.socksProxyHost,
          socksProxyPort: existingSettings.socksProxyPort,
          onionHostOption: EOnionHostOption.values[existingSettings.onionHostOption.index],
        );
      }

      HttpOverrides.global = ChuCHuHttpOverrides();
    } catch (e) {
      _proxySettings = ProxySettings(
        turnOnProxy: false,
        socksProxyHost: _defaultHost,
        socksProxyPort: _defaultPort,
        onionHostOption: EOnionHostOption.whenAvailable,
      );
      HttpOverrides.global = ChuCHuHttpOverrides();
    }
  }

  Future<void> syncHistoricalSettings() async {
    try {
      final existingSettings = config.Config.sharedInstance.proxySettings;
      if (existingSettings != null && existingSettings.turnOnProxy) {
        if (_proxySettings.socksProxyHost != existingSettings.socksProxyHost ||
            _proxySettings.socksProxyPort != existingSettings.socksProxyPort) {
          _proxySettings = ProxySettings(
            turnOnProxy: existingSettings.turnOnProxy,
            socksProxyHost: existingSettings.socksProxyHost,
            socksProxyPort: existingSettings.socksProxyPort,
            onionHostOption: EOnionHostOption.values[existingSettings.onionHostOption.index],
          );
          
          HttpOverrides.global = ChuCHuHttpOverrides();
          
          try {
            await _syncToDatabase();
          } catch (e) {
            // Database may not be initialized yet
          }
        }
      }
    } catch (e) {
      // Ignore sync errors
    }
  }

  Future<void> setProxy(String host, int port) async {
    try {
      if (!_validateConfig(host, port)) {
        throw Exception('Invalid proxy configuration: $host:$port');
      }

      _proxySettings = ProxySettings(
        turnOnProxy: true,
        socksProxyHost: host,
        socksProxyPort: port,
        onionHostOption: EOnionHostOption.whenAvailable,
      );

      HttpOverrides.global = ChuCHuHttpOverrides();

      try {
        await _syncToDatabase();
      } catch (e) {
        // Database may not be available
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setProxyEnabled(bool enabled) async {
    try {
      _proxySettings.turnOnProxy = enabled;
      await _syncToAllSystems();
    } catch (e) {
      rethrow;
    }
  }

  /// Reset to default configuration
  Future<void> resetToDefaults() async {
    await setProxy(_defaultHost, _defaultPort);
  }

  /// Get proxy string for network configuration
  String get proxyString {
    if (!_proxySettings.turnOnProxy) return 'DIRECT';
    return 'PROXY ${_proxySettings.socksProxyHost}:${_proxySettings.socksProxyPort}';
  }

  /// Get environment variables
  Map<String, String> get environmentVariables {
    if (!_proxySettings.turnOnProxy) return {};
    
    return {
      'HTTP_PROXY': 'http://${_proxySettings.socksProxyHost}:${_proxySettings.socksProxyPort}',
      'HTTPS_PROXY': 'http://${_proxySettings.socksProxyHost}:${_proxySettings.socksProxyPort}',
      'NO_PROXY': 'localhost,127.0.0.1,::1,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12',
    };
  }

  void printCurrentConfig() {
    print('Proxy: ${_proxySettings.socksProxyHost}:${_proxySettings.socksProxyPort} (${_proxySettings.turnOnProxy ? 'enabled' : 'disabled'})');
  }

  /// Validate proxy configuration
  bool _validateConfig(String host, int port) {
    // Basic validation
    if (host.isEmpty || port <= 0 || port > 65535) {
      return false;
    }

    // Check if host is valid IP or domain
    try {
      if (host.contains('.')) {
        // IP address validation
        final parts = host.split('.');
        if (parts.length != 4) return false;
        
        for (final part in parts) {
          final num = int.parse(part);
          if (num < 0 || num > 255) return false;
        }
      }
    } catch (e) {
      return false;
    }

    return true;
  }

  Future<void> _syncToAllSystems() async {
    try {
      final configSettings = _convertToConfigProxySettings(_proxySettings);
      config.Config.sharedInstance.proxySettings = configSettings;

      try {
        await _syncToDatabase();
      } catch (e) {
        // Database may not be available
      }

      HttpOverrides.global = ChuCHuHttpOverrides();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _syncToDatabase() async {
    try {
      if (config.Config.sharedInstance.proxySettings != null) {
        final configSettings = _convertToConfigProxySettings(_proxySettings);
        await config.Config.sharedInstance.setProxy(configSettings);
      }
    } catch (e) {
      rethrow;
    }
  }

  ProxySettings _convertToConfigProxySettings(ProxySettings localSettings) {
    return ProxySettings(
      turnOnProxy: localSettings.turnOnProxy,
      socksProxyHost: localSettings.socksProxyHost,
      socksProxyPort: localSettings.socksProxyPort,
      onionHostOption: localSettings.onionHostOption,
    );
  }

  /// Check if configuration is valid
  bool get isConfigurationValid => _validateConfig(_proxySettings.socksProxyHost, _proxySettings.socksProxyPort);

  /// Get configuration summary
  Map<String, dynamic> getConfigurationSummary() {
    return {
      'host': _proxySettings.socksProxyHost,
      'port': _proxySettings.socksProxyPort,
      'enabled': _proxySettings.turnOnProxy,
      'valid': isConfigurationValid,
      'proxyString': proxyString,
      'environmentVariables': environmentVariables,
    };
  }
}
