import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureAccountStorage {
  SecureAccountStorage._();
  static final SecureAccountStorage instance = SecureAccountStorage._();

  static const String _privkeyKey = 'chuchu_user_privkey';
  static const String _privkeyMapKey = 'chuchu_user_privkey_map';

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const AndroidOptions _androidOptions =
  AndroidOptions(encryptedSharedPreferences: true);
  static const IOSOptions _iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );
  static const MacOsOptions _macOptions = MacOsOptions();
  static const LinuxOptions _linuxOptions = LinuxOptions();
  static const WindowsOptions _windowsOptions = WindowsOptions();
  static const WebOptions _webOptions = WebOptions(
    dbName: 'chuchu_secure_store',
    publicKey: 'chuchu_secure_storage',
  );

  static Future<void> savePrivateKey(String privkey, {String? pubkey}) async {
    if (privkey.isEmpty) return;
    try {
      await _storage.write(
        key: _privkeyKey,
        value: privkey,
        aOptions: _androidOptions,
        iOptions: _iosOptions,
        mOptions: _macOptions,
        lOptions: _linuxOptions,
        wOptions: _windowsOptions,
        webOptions: _webOptions,
      );

      if (pubkey != null && pubkey.isNotEmpty) {
        await savePrivateKeyForPubkey(pubkey, privkey);
      }
    } catch (e) {
      debugPrint('[SecureAccountStorage] failed to save privkey: $e');
    }
  }

  static Future<String?> readPrivateKey() async {
    try {
      return await _storage.read(
        key: _privkeyKey,
        aOptions: _androidOptions,
        iOptions: _iosOptions,
        mOptions: _macOptions,
        lOptions: _linuxOptions,
        wOptions: _windowsOptions,
        webOptions: _webOptions,
      );
    } catch (e) {
      debugPrint('[SecureAccountStorage] failed to read privkey: $e');
      return null;
    }
  }

  static Future<void> clearPrivateKey() async {
    try {
      await _storage.delete(
        key: _privkeyKey,
        aOptions: _androidOptions,
        iOptions: _iosOptions,
        mOptions: _macOptions,
        lOptions: _linuxOptions,
        wOptions: _windowsOptions,
        webOptions: _webOptions,
      );
    } catch (e) {
      debugPrint('[SecureAccountStorage] failed to clear privkey: $e');
    }
  }

  static Future<void> savePrivateKeyForPubkey(String pubkey, String privkey) async {
    if (pubkey.isEmpty || privkey.isEmpty) return;
    try {
      final map = await _readPrivkeyMap();
      map[pubkey] = privkey;
      await _writePrivkeyMap(map);
    } catch (e) {
      debugPrint('[SecureAccountStorage] failed to save privkey for $pubkey: $e');
    }
  }

  static Future<String?> readPrivateKeyForPubkey(String pubkey) async {
    if (pubkey.isEmpty) return null;
    try {
      final map = await _readPrivkeyMap();
      return map[pubkey];
    } catch (e) {
      debugPrint('[SecureAccountStorage] failed to read privkey for $pubkey: $e');
      return null;
    }
  }

  static Future<void> clearPrivateKeyForPubkey(String pubkey) async {
    if (pubkey.isEmpty) return;
    try {
      final map = await _readPrivkeyMap();
      if (map.remove(pubkey) != null) {
        if (map.isEmpty) {
          await _storage.delete(
            key: _privkeyMapKey,
            aOptions: _androidOptions,
            iOptions: _iosOptions,
            mOptions: _macOptions,
            lOptions: _linuxOptions,
            wOptions: _windowsOptions,
            webOptions: _webOptions,
          );
        } else {
          await _writePrivkeyMap(map);
        }
      }
    } catch (e) {
      debugPrint('[SecureAccountStorage] failed to clear privkey for $pubkey: $e');
    }
  }

  static Future<Map<String, String>> _readPrivkeyMap() async {
    try {
      final raw = await _storage.read(
        key: _privkeyMapKey,
        aOptions: _androidOptions,
        iOptions: _iosOptions,
        mOptions: _macOptions,
        lOptions: _linuxOptions,
        wOptions: _windowsOptions,
        webOptions: _webOptions,
      );
      if (raw == null || raw.isEmpty) return {};
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded.map((key, value) => MapEntry(key, value?.toString() ?? ''));
      }
      return {};
    } catch (e) {
      debugPrint('[SecureAccountStorage] failed to read privkey map: $e');
      return {};
    }
  }

  static Future<void> _writePrivkeyMap(Map<String, String> map) async {
    await _storage.write(
      key: _privkeyMapKey,
      value: jsonEncode(map),
      aOptions: _androidOptions,
      iOptions: _iosOptions,
      mOptions: _macOptions,
      lOptions: _linuxOptions,
      wOptions: _windowsOptions,
      webOptions: _webOptions,
    );
  }
}

