import 'dart:async';

import 'chuchu_file_cache.dart';
import 'chuchu_simple_cache.dart';

enum EChuChuCacheType {
  Simple, //iOS  UserDefault && SharedPreferences
  File, //
}

class ChuChuCacheManager {
  String filepath;
  String simplePath;
  late ChuChuSimpleCache _simpleCache;
  late ChuChuFileCache _fileCache;

  ChuChuCacheManager({
    this.filepath = "chuchu_super_filecache",
    this.simplePath = "chuchu_super_simplecache",
  }) {
    _simpleCache = ChuChuSimpleCache(this.simplePath);
    _fileCache = ChuChuFileCache(this.filepath);
  }

  static ChuChuCacheManager defaultOXCacheManager = new ChuChuCacheManager(
    filepath: "chuchu_super_filecache",
    simplePath: "chuchu_super_simplecache",
  );

  Future<bool> saveData(
    String key,
    dynamic data, {
        EChuChuCacheType cacheType = EChuChuCacheType.Simple,
  }) async {
    switch (cacheType) {
      case EChuChuCacheType.Simple:
        return await _simpleCache.saveData(key, data);
        break;
      case EChuChuCacheType.File:
        return await _fileCache.saveData(key, data);
        break;
    }
  }

  Future<bool> saveListData(String key, List<String> datas) async {
    return await _simpleCache.saveListData(key, datas);
  }

  Future<List<String>> getListData(String key) async {
    return await _simpleCache.getListData(key);
  }

  Future<bool> saveForeverData(
    String key,
    dynamic data, {
        EChuChuCacheType cacheType = EChuChuCacheType.Simple,
  }) async {
    switch (cacheType) {
      case EChuChuCacheType.Simple:
        return await _simpleCache.saveForeverData(key, data);
      case EChuChuCacheType.File:
        return await _fileCache.saveForeverData(key, data);
    }
  }

  Future<dynamic> getForeverData(
    String key, {
        EChuChuCacheType cacheType = EChuChuCacheType.Simple,
    dynamic defaultValue,
  }) async {
    switch (cacheType) {
      case EChuChuCacheType.Simple:
        return _simpleCache.getForeverData(key, defaultValue: defaultValue);
      case EChuChuCacheType.File:
        return await _fileCache.getForeverData(key, defaultValue: defaultValue);
    }
  }

  Future<dynamic> getData(
    String key, {
        EChuChuCacheType cacheType = EChuChuCacheType.Simple,
    dynamic defaultValue = "",
  }) async {
    switch (cacheType) {
      case EChuChuCacheType.Simple:
        return _simpleCache.getData(key, defaultValue: defaultValue);
      case EChuChuCacheType.File:
        return await _fileCache.getData(key, defaultValue: defaultValue);
    }
  }

  Future<bool> removeData(
    String key, {
        EChuChuCacheType cacheType = EChuChuCacheType.Simple,
  }) async {
    switch (cacheType) {
      case EChuChuCacheType.Simple:
        return _simpleCache.removeData(key);
      case EChuChuCacheType.File:
        return await _fileCache.removeData(key);
    }
  }

  clearData() async {
    //Clear all caches
    await _simpleCache.clearData();
    await _fileCache.clearData();
  }

  Future<double> cacheSize() async {
    double totalSize = await _fileCache.cacheSize();
    return totalSize;
  }
}
