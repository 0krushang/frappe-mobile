import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user/frappe_user.dart';
import '../utils/constants.dart';
import '../utils/exceptions.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }


  Future<void> storeUser(FrappeUser user) async {
    try {
      await _secureStorage.write(
        key: FrappeConstants.userStorageKey,
        value: user.toJsonString(),
      );
      
      final prefs = await _getPrefs();
      await prefs.setBool(FrappeConstants.isLoggedInKey, true);
    } catch (e) {
      throw FrappeException.storage('Failed to store user data: $e');
    }
  }


  Future<FrappeUser?> getUser() async {
    try {
      final userData = await _secureStorage.read(key: FrappeConstants.userStorageKey);
      if (userData != null) {
        return FrappeUser.fromJsonString(userData);
      }
      return null;
    } catch (e) {
      throw FrappeException.storage('Failed to retrieve user data: $e');
    }
  }


  Future<bool> isUserLoggedIn() async {
    try {
      final prefs = await _getPrefs();
      final isLoggedIn = prefs.getBool(FrappeConstants.isLoggedInKey) ?? false;
      
      if (isLoggedIn) {

        final user = await getUser();
        return user != null;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }


  Future<void> storeSiteUrl(String url) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setString(FrappeConstants.siteUrlKey, url);
    } catch (e) {
      throw FrappeException.storage('Failed to store site URL: $e');
    }
  }


  Future<String?> getSiteUrl() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getString(FrappeConstants.siteUrlKey);
    } catch (e) {
      throw FrappeException.storage('Failed to retrieve site URL: $e');
    }
  }


  Future<void> cacheData(String key, dynamic data) async {
    try {
      final prefs = await _getPrefs();
      final cacheItem = {
        'data': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      
      await prefs.setString('cache_$key', jsonEncode(cacheItem));
    } catch (e) {
      throw FrappeException.storage('Failed to cache data: $e');
    }
  }


  Future<Map<String, dynamic>?> getCachedData(String key) async {
    try {
      final prefs = await _getPrefs();
      final cacheString = prefs.getString('cache_$key');
      
      if (cacheString != null) {
        final cacheItem = jsonDecode(cacheString) as Map<String, dynamic>;
        final timestamp = cacheItem['timestamp'] as int;
        final expiration = cacheItem['expiration'] as int;
        
        final now = DateTime.now().millisecondsSinceEpoch;
        
        if (now - timestamp < expiration) {
          return cacheItem;
        } else {

          await prefs.remove('cache_$key');
        }
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }


  Future<void> removeCachedData(String key) async {
    try {
      final prefs = await _getPrefs();
      await prefs.remove('cache_$key');
    } catch (e) {
      throw FrappeException.storage('Failed to remove cached data: $e');
    }
  }


  Future<void> storeString(String key, String value) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setString(key, value);
    } catch (e) {
      throw FrappeException.storage('Failed to store string data: $e');
    }
  }


  Future<String?> getString(String key) async {
    try {
      final prefs = await _getPrefs();
      return prefs.getString(key);
    } catch (e) {
      return null;
    }
  }

  
  Future<void> storeBool(String key, bool value) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setBool(key, value);
    } catch (e) {
      throw FrappeException.storage('Failed to store boolean data: $e');
    }
  }

  
  Future<bool?> getBool(String key) async {
    try {
      final prefs = await _getPrefs();
      return prefs.getBool(key);
    } catch (e) {
      return null;
    }
  }

  
  Future<void> storeInt(String key, int value) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setInt(key, value);
    } catch (e) {
      throw FrappeException.storage('Failed to store integer data: $e');
    }
  }

  
  Future<int?> getInt(String key) async {
    try {
      final prefs = await _getPrefs();
      return prefs.getInt(key);
    } catch (e) {
      return null;
    }
  }

  
  Future<void> storeJson(String key, Map<String, dynamic> data) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setString(key, jsonEncode(data));
    } catch (e) {
      throw FrappeException.storage('Failed to store JSON data: $e');
    }
  }

  
  Future<Map<String, dynamic>?> getJson(String key) async {
    try {
      final prefs = await _getPrefs();
      final jsonString = prefs.getString(key);
      
      if (jsonString != null) {
        return Map<String, dynamic>.from(jsonDecode(jsonString));
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  
  Future<void> storeSecureString(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
    } catch (e) {
      throw FrappeException.storage('Failed to store secure string: $e');
    }
  }

  
  Future<String?> getSecureString(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      return null;
    }
  }

  
  Future<void> removeData(String key) async {
    try {
      final prefs = await _getPrefs();
      
      
      if (prefs.containsKey(key)) {
        await prefs.remove(key);
      }
      
      
      if (prefs.containsKey('cache_$key')) {
        await prefs.remove('cache_$key');
      }
      

      await _secureStorage.delete(key: key);
    } catch (e) {
      throw FrappeException.storage('Failed to remove data: $e');
    }
  }

  Future<void> clearAllData() async {
    try {
      await _secureStorage.delete(key: FrappeConstants.userStorageKey);
      
      final prefs = await _getPrefs();
      await prefs.remove(FrappeConstants.isLoggedInKey);
      
      final keys = prefs.getKeys().where((key) => key.startsWith('cache_')).toList();
      for (final key in keys) {
        await prefs.remove(key);
      }
    } catch (e) {
      throw FrappeException.storage('Failed to clear all data: $e');
    }
  }

  Future<void> clearAllCache() async {
    try {
      final prefs = await _getPrefs();
      final cacheKeys = prefs.getKeys().where((key) => key.startsWith('cache_')).toList();
      
      for (final key in cacheKeys) {
        await prefs.remove(key);
      }
    } catch (e) {
      throw FrappeException.storage('Failed to clear cache: $e');
    }
  }

  Future<Map<String, dynamic>> getStorageInfo() async {
    try {
      final prefs = await _getPrefs();
      final allKeys = prefs.getKeys();
      final cacheKeys = allKeys.where((key) => key.startsWith('cache_')).toList();
      
      return {
        'total_keys': allKeys.length,
        'cache_keys': cacheKeys.length,
        'user_logged_in': await isUserLoggedIn(),
        'site_url_configured': await getSiteUrl() != null,
        'cache_keys_list': cacheKeys,
      };
    } catch (e) {
      return {
        'error': 'Failed to get storage info: $e',
      };
    }
  }
}