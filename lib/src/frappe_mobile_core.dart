import 'dart:io';
import 'package:dio/dio.dart';
import 'models/frappe_user.dart';
import 'services/authentication_service.dart';
import 'services/storage_service.dart';
import 'services/api_service.dart';

class FrappeMobile {
  static final FrappeMobile _instance = FrappeMobile._internal();
  factory FrappeMobile() => _instance;
  FrappeMobile._internal();

  final AuthenticationService _auth = AuthenticationService();
  final StorageService _storage = StorageService();
  final ApiService _api = ApiService();

  // Get current site URL
  static Future<String?> getSiteUrl() async {
    return await StorageService().getSiteUrl();
  }

  // Authentication methods
  static Future<FrappeUser> login(String username, String password) async {
    return await AuthenticationService().login(username, password);
  }

  static Future<void> logout() async {
    await AuthenticationService().logout();
  }

  static Future<bool> isUserLoggedIn() async {
    return await AuthenticationService().isUserLoggedIn();
  }

  static Future<FrappeUser?> getUser() async {
    return await AuthenticationService().getCurrentUser();
  }

  static Future<FrappeUser?> refreshUser() async {
    return await AuthenticationService().refreshUser();
  }

  // API helper method
  static Future<Response> makeApiCall({
    required String endpoint,
    required String method,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool includeAuth = true,
  }) async {
    final response = await ApiService().makeApiCall(
      endpoint: endpoint,
      method: method,
      data: data,
      queryParameters: queryParameters,
      includeAuth: includeAuth,
    );
    return response;
  }

  // File upload helper
  static Future<Response> uploadFile({
    required String endpoint,
    required File file,
    String fileFieldName = 'file',
    Map<String, dynamic>? additionalData,
    bool includeAuth = true,
    void Function(int, int)? onSendProgress,
  }) async {
    return await ApiService().uploadFile(
      endpoint: endpoint,
      file: file,
      fileFieldName: fileFieldName,
      additionalData: additionalData,
      includeAuth: includeAuth,
      onSendProgress: onSendProgress,
    );
  }

  // File download helper
  static Future<Response> downloadFile({
    required String endpoint,
    required String savePath,
    bool includeAuth = true,
    void Function(int, int)? onReceiveProgress,
  }) async {
    return await ApiService().downloadFile(
      endpoint: endpoint,
      savePath: savePath,
      includeAuth: includeAuth,
      onReceiveProgress: onReceiveProgress,
    );
  }

  // Initialize the package
  static Future<void> initialize({required String siteUrl}) async {
    String formattedUrl = siteUrl;
    
    // Ensure URL doesn't end with slash
    if (formattedUrl.endsWith('/')) {
      formattedUrl = formattedUrl.substring(0, formattedUrl.length - 1);
    }
    
    // Ensure URL starts with http or https
    if (!formattedUrl.startsWith('http://') && !formattedUrl.startsWith('https://')) {
      formattedUrl = 'https://$formattedUrl';
    }
    
    // Store the formatted URL
    await StorageService().storeSiteUrl(formattedUrl);
    
    // Initialize Dio in API service
    await ApiService().initializeDio();
  }
}

// Authentication class for organized access
class Authentication {
  static Future<FrappeUser> login(String username, String password) {
    return FrappeMobile.login(username, password);
  }

  static Future<void> logout() {
    return FrappeMobile.logout();
  }

  static Future<bool> isUserLoggedIn() {
    return FrappeMobile.isUserLoggedIn();
  }

  static Future<FrappeUser?> getUser() {
    return FrappeMobile.getUser();
  }

  static Future<FrappeUser?> refreshUser() {
    return FrappeMobile.refreshUser();
  }
}