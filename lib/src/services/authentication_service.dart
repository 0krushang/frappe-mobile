import '../models/frappe_user.dart';
import '../utils/constants.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthenticationService {
  static final AuthenticationService _instance = AuthenticationService._internal();
  factory AuthenticationService() => _instance;
  AuthenticationService._internal();

  final ApiService _api = ApiService();
  final StorageService _storage = StorageService();

  // Login method
  Future<FrappeUser> login(String username, String password) async {
    try {
      final loginResponse = await _api.login(username, password);
      
      // Extract user data from login response
      final user = FrappeUser(
        name: loginResponse['user'] ?? username,
        email: loginResponse['email'] ?? username,
        fullName: loginResponse['full_name'] ?? username,
        apiKey: loginResponse['api_key'] ?? '',
        apiSecret: loginResponse['api_secret'] ?? '',
        userId: loginResponse['user_id'] ?? loginResponse['user'] ?? username,
        roles: List<String>.from(loginResponse['roles'] ?? []),
        lastLogin: DateTime.now(),
      );

      // Store user data
      await _storage.storeUser(user);

      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      // Call logout API
      await _api.logout();
    } catch (e) {
      // Continue with local logout even if API call fails
    } finally {
      // Clear local data
      await _storage.clearAllData();
    }
  }

  // Check if user is logged in
  Future<bool> isUserLoggedIn() async {
    return await _storage.isUserLoggedIn();
  }

  // Get current user
  Future<FrappeUser?> getCurrentUser() async {
    return await _storage.getUser();
  }

  // Refresh user data
  Future<FrappeUser?> refreshUser() async {
    try {
      if (!await isUserLoggedIn()) return null;
      
      final userInfo = await _api.getUserInfo();
      final currentUser = await getCurrentUser();
      
      if (currentUser != null) {
        final updatedUser = currentUser.copyWith(
          name: userInfo['name'] ?? currentUser.name,
          email: userInfo['email'] ?? currentUser.email,
          fullName: userInfo['full_name'] ?? currentUser.fullName,
          roles: List<String>.from(userInfo['roles'] ?? currentUser.roles),
        );
        
        await _storage.storeUser(updatedUser);
        return updatedUser;
      }
      
      return null;
    } catch (e) {
      return await getCurrentUser();
    }
  }
}