import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureAccountStorage {
  SecureAccountStorage._();
  static final SecureAccountStorage instance = SecureAccountStorage._();

  static const String _privkeyKey = 'chuchu_user_privkey';

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

  static Future<void> savePrivateKey(String privkey) async {
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
}

