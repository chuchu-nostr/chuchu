import 'dart:convert';

/// Proxy configuration data model
/// Defines the structure for proxy settings
class ProxySettings {
  bool turnOnProxy;
  String socksProxyHost;
  int socksProxyPort;
  EOnionHostOption onionHostOption;

  ProxySettings({
    this.turnOnProxy = true,
    this.socksProxyHost = '127.0.0.1',
    this.socksProxyPort = 7890,
    this.onionHostOption = EOnionHostOption.whenAvailable,
  });

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'turnOnProxy': turnOnProxy,
      'socksProxyHost': socksProxyHost,
      'socksProxyPort': socksProxyPort,
      'onionHostOption': onionHostOption.index,
    };
  }

  /// Create from JSON map
  factory ProxySettings.fromJson(Map<String, dynamic> json) {
    return ProxySettings(
      turnOnProxy: json['turnOnProxy'] ?? true,
      socksProxyHost: json['socksProxyHost'] ?? '127.0.0.1',
      socksProxyPort: json['socksProxyPort'] ?? 7890,
      onionHostOption: EOnionHostOption.values[json['onionHostOption'] ?? 1],
    );
  }

  /// Convert to JSON string
  String toJsonString() {
    final jsonData = toJson();
    return jsonEncode(jsonData);
  }

  /// Create from JSON string
  factory ProxySettings.fromJsonString(String jsonString) {
    try {
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      return ProxySettings.fromJson(jsonData);
    } catch (e) {
      // Return default settings if parsing fails
      return ProxySettings();
    }
  }

  /// Create a copy with updated values
  ProxySettings copyWith({
    bool? turnOnProxy,
    String? socksProxyHost,
    int? socksProxyPort,
    EOnionHostOption? onionHostOption,
  }) {
    return ProxySettings(
      turnOnProxy: turnOnProxy ?? this.turnOnProxy,
      socksProxyHost: socksProxyHost ?? this.socksProxyHost,
      socksProxyPort: socksProxyPort ?? this.socksProxyPort,
      onionHostOption: onionHostOption ?? this.onionHostOption,
    );
  }

  /// Check if settings are equal
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProxySettings &&
        other.turnOnProxy == turnOnProxy &&
        other.socksProxyHost == socksProxyHost &&
        other.socksProxyPort == socksProxyPort &&
        other.onionHostOption == onionHostOption;
  }

  @override
  int get hashCode {
    return turnOnProxy.hashCode ^
        socksProxyHost.hashCode ^
        socksProxyPort.hashCode ^
        onionHostOption.hashCode;
  }

  @override
  String toString() {
    return 'ProxySettings(turnOnProxy: $turnOnProxy, host: $socksProxyHost, port: $socksProxyPort, onionOption: $onionHostOption)';
  }
}

/// Onion host handling options
enum EOnionHostOption { 
  no,           // Never use proxy for onion sites
  whenAvailable, // Use proxy for onion sites when available
  required      // Always require proxy for onion sites
}
