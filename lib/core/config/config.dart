/// 0xchat config based on relay events
/// 1.DNS configs 2.Discovery configs 3.Proxy configs (delegated to UnifiedProxyManager)

import 'dart:convert';

import 'package:isar/isar.dart';

import '../account/account.dart';
import '../database/db_isar.dart';
import '../network/connect.dart';
import '../nostr_dart/nostr.dart';
import '../utils/log_utils.dart';
import '../proxy/unified_proxy_manager.dart';
import '../proxy/proxy_settings.dart';
import 'configDB_isar.dart';

/// Application configuration manager
/// Handles DNS, discovery, and proxy configuration (proxy logic delegated to UnifiedProxyManager)
class Config {
  /// Singleton instance
  Config._internal();

  factory Config() => sharedInstance;
  static final Config sharedInstance = Config._internal();

  Map<String, ConfigDBISAR> configs = {};
  ProxySettings? proxySettings;

  // recommendChannels config
  List<String> recommendChannels = [
    'db0c7f767e730c71e008ca674094fd6446abc4404a5a04197f5516779f627752',
    '25e5c82273a271cb1a840d0060391a0bf4965cafeb029d5ab55350b418953fbb',
    '40b50ef7e5c83e12b106e45c4646a07c722e08676455cd6e796e7ae1c82ac5f5'
  ];
  // host config
  Map<String, String> hostConfig = {
    "wss://relay.0xchat.com": "wss://52.76.210.159",
    "www.0xchat.com": "52.76.210.159:9602",
    "mint.0xchat.com": "35.181.15.130:3337",
    "wss://groups.0xchat.com": "wss://54.191.231.210/groups",
  };
  final String _serverPubkey = '093dff31a87bbf838c54fd39ff755e72b38bd6b7975c670c0f2633fa7c54ddd0';
  final String configD = '0xchat-config';
  final String wssHost = 'wss://relay.0xchat.com';
  final String httpHost = 'www.0xchat.com';
  final String mintHost = 'mint.0xchat.com';
  final String relayGroupHost = 'wss://groups.0xchat.com';

  Future<void> initConfig() async {
    // subscript friend requests
    Connect.sharedInstance.addConnectStatusListener((relay, status, relayKinds) async {
      if (status == 1 &&
          Account.sharedInstance.me != null &&
          relayKinds.contains(RelayKind.general)) {
        _loadConfigFromRelay(relay: relay);
      }
    });
    await _loadConfig();
  }

  Future<void> _loadConfig() async {
    await _loadConfigFromDB();
    _loadConfigFromRelay();
  }

  Future<void> _loadConfigFromDB() async {
    final isar = DBISAR.sharedInstance.isar;
    List<Object?> maps = await isar.configDBISARs.where().findAll();
    configs = {for (var configDB in maps) (configDB as ConfigDBISAR).d: configDB};
    _setConfig();
    await _loadProxy();
  }

  void _loadConfigFromRelay({String? relay}) {
    Map<String, List<Filter>> subscriptions = {};
    Filter f = Filter(kinds: [30078], d: [configD], authors: [_serverPubkey], limit: 1);

    if (relay == null) {
      for (var r in Connect.sharedInstance.relays()) {
        subscriptions[r] = [f];
      }
    } else {
      subscriptions[relay] = [f];
    }

    Connect.sharedInstance.addSubscriptions(subscriptions, eventCallBack: (event, relay) {
      switch (event.kind) {
        case 30078:
          _handleAppData(event);
          break;
        default:
          LogUtils.v(() => 'config unhandled message ${event.toJson()}');
          break;
      }
    });
  }

  Future<void> _handleAppData(Event event) async {
    AppData appData = Nip78.decodeAppData(event);
    ConfigDBISAR configDB = ConfigDBISAR(
        d: appData.d ?? '',
        eventId: event.id,
        time: appData.createAt,
        configJson: appData.content,
        proxyJson: proxySettings?.toJsonString() ?? '');
    configs[configDB.d] = configDB;
    _setConfig();
    await DBISAR.sharedInstance.saveToDB(configDB);
  }

  void _setConfig() {
    String? json = configs[configD]?.configJson;
    if (json != null) {
      Map map = jsonDecode(json);

      String? wssdns = map['wssdnsnew'];
      hostConfig[wssHost] = 'wss://${wssdns ?? '52.76.210.159'}';

      String? httpsdns = map['httpsdnsnew'];
      hostConfig[httpHost] = httpsdns ?? '52.76.210.159:9602';

      List<String>? channels =
      (map['recommendChannels'] as List<dynamic>?)?.map((item) => item.toString()).toList();
      if (channels != null) recommendChannels = channels;

      String? mintdns = map['mintdnsnew'];
      hostConfig[mintHost] = mintdns ?? '35.181.15.130:3337';

      String? relayGroupdns = map['wssgroupdns'];
      hostConfig[relayGroupHost] = 'wss://${relayGroupdns ?? '54.191.231.210/groups'}';
    }
  }

  Future<void> _loadProxy() async {
    String? json = configs[configD]?.proxyJson;
    if (json != null) {
      try {
        final loadedSettings = ProxySettings.fromJsonString(json);
        proxySettings = loadedSettings;
        
        print('🔧 Historical proxy settings loaded: ${loadedSettings.socksProxyHost}:${loadedSettings.socksProxyPort}');
        print('🔧 Note: Proxy will be synced when UnifiedProxyManager initializes');
        
      } catch (_) {
        proxySettings = ProxySettings(turnOnProxy: false);
        print('⚠️ Failed to load proxy settings, using defaults');
      }
    } else {
      print('🔧 No historical proxy settings found, will use defaults');
    }
  }

  ProxySettings getProxy() {
    return proxySettings ?? ProxySettings(turnOnProxy: false);
  }

  Future<void> setProxy(ProxySettings setting) async {
    try {
      proxySettings = setting;
      
      configs[configD] ??= ConfigDBISAR(d: configD);
      configs[configD]!.proxyJson = proxySettings!.toJsonString();
      await DBISAR.sharedInstance.saveToDB(configs[configD]!);
      
      try {
        final proxyManager = UnifiedProxyManager();
        await proxyManager.setProxy(setting.socksProxyHost, setting.socksProxyPort);
        print('🔧 Proxy settings updated and synced to unified manager');
      } catch (e) {
        print('⚠️ Failed to sync to unified manager: $e');
      }
      
      await Connect.sharedInstance.resetConnection();
      
    } catch (e) {
      print('⚠️ Failed to update proxy settings: $e');
      rethrow;
    }
  }
}
