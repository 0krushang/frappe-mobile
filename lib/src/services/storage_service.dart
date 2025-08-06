import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/frappe_user.dart';
import '../utils/constants.dart';

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

  // Store user data securely
  Future<void> storeUser(FrappeUser user) async {
    try {
      await _secureStorage.write(
        key: FrappeConstants.userStorageKey,
        value: user.toJsonString(),
      );
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(FrappeConstants.isLoggedInKey, true);
    } catch (e) {
      throw Exception('Failed to store user data: $e');
    }
  }

  // Retrieve user data
  Future<FrappeUser?> getUser() async {
    try {
      final userData = await _secureStorage.read(key: FrappeConstants.userStorageKey);
      if (userData != null) {
        return FrappeUser.fromJsonString(userData);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to retrieve user data: $e');
    }
  }

  // Store site URL
  Future<void> storeSiteUrl(String url) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(FrappeConstants.siteUrlKey, url);
    } catch (e) {
      throw Exception('Failed to store site URL: $e');
    }
  }

  // Get site URL
  Future<String?> getSiteUrl() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(FrappeConstants.siteUrlKey);
    } catch (e) {
      throw Exception('Failed to retrieve site URL: $e');
    }
  }

  // Check if user is logged in
  Future<bool> isUserLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
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

  // Clear all stored data
  Future<void> clearAllData() async {
    try {
      await _secureStorage.delete(key: FrappeConstants.userStorageKey);
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(FrappeConstants.isLoggedInKey);
    } catch (e) {
      throw Exception('Failed to clear user data: $e');
    }
  }
}