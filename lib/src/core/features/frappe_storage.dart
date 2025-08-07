import 'package:frappe_mobile/src/services/storage_service.dart';
import '../../models/user/frappe_user.dart';

class FrappeStorage {
  static final FrappeStorage _instance = FrappeStorage._internal();
  factory FrappeStorage() => _instance;
  FrappeStorage._internal();

  Future<void> storeUser(FrappeUser user) async {
    return await StorageService().storeUser(user);
  }

  Future<FrappeUser?> getUser() async {
    return await StorageService().getUser();
  }

  Future<bool> isUserLoggedIn() async {
    return await StorageService().isUserLoggedIn();
  }

  Future<void> storeSiteUrl(String url) async {
    return await StorageService().storeSiteUrl(url);
  }

  Future<String?> getSiteUrl() async {
    return await StorageService().getSiteUrl();
  }

  Future<void> cacheData(String key, dynamic data, Duration expiration) async {
    return await StorageService().cacheData(key, data, expiration);
  }

  Future<Map<String, dynamic>?> getCachedData(String key) async {
    return await StorageService().getCachedData(key);
  }

  Future<void> removeCachedData(String key) async {
    return await StorageService().removeCachedData(key);
  }

  Future<void> clearAllCache() async {
    return await StorageService().clearAllCache();
  }

  Future<void> storeString(String key, String value) async {
    return await StorageService().storeString(key, value);
  }

  Future<String?> getString(String key) async {
    return await StorageService().getString(key);
  }

  Future<void> storeBool(String key, bool value) async {
    return await StorageService().storeBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    return await StorageService().getBool(key);
  }

  Future<void> storeInt(String key, int value) async {
    return await StorageService().storeInt(key, value);
  }

  Future<int?> getInt(String key) async {
    return await StorageService().getInt(key);
  }

  Future<void> storeJson(String key, Map<String, dynamic> data) async {
    return await StorageService().storeJson(key, data);
  }

  Future<Map<String, dynamic>?> getJson(String key) async {
    return await StorageService().getJson(key);
  }

  Future<void> storeSecureString(String key, String value) async {
    return await StorageService().storeSecureString(key, value);
  }

  Future<String?> getSecureString(String key) async {
    return await StorageService().getSecureString(key);
  }

  Future<void> removeData(String key) async {
    return await StorageService().removeData(key);
  }

  Future<void> clearAllData() async {
    return await StorageService().clearAllData();
  }

  Future<Map<String, dynamic>> getStorageInfo() async {
    return await StorageService().getStorageInfo();
  }
} 