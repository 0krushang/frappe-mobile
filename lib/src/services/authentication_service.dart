import '../models/user/frappe_user.dart';
import '../api/services/auth_api_service.dart';
import 'storage_service.dart';
import '../utils/exceptions.dart';

class AuthenticationService {
  static final AuthenticationService _instance = AuthenticationService._internal();
  factory AuthenticationService() => _instance;
  AuthenticationService._internal();

  final AuthApiService _authApi = AuthApiService();
  final StorageService _storage = StorageService();

  Future<FrappeUser> login(String username, String password) async {
    try {
      if (username.isEmpty || password.isEmpty) {
        throw FrappeException.validation('Username and password are required');
      }

      final loginResponse = await _authApi.login(
        username: username,
        password: password,
      );

      final user = FrappeUser(
        name: loginResponse['user'] ?? username,
        email: loginResponse['email'] ?? username,
        fullName: loginResponse['full_name'] ?? username,
        apiKey: loginResponse['api_key'] ?? '',
        apiSecret: loginResponse['api_secret'] ?? '',
        username: loginResponse['user'] ?? username,
        firstName: loginResponse['first_name'] ?? '',
        lastName: loginResponse['last_name'] ?? '',
        timeZone: loginResponse['time_zone'] ?? '',
        userType: loginResponse['user_type'] ?? '',
        lastIp: loginResponse['last_ip'] ?? '',
        roles: _parseRoles(loginResponse['roles'] ?? []),
        roleProfiles: List<String>.from(loginResponse['role_profiles'] ?? []),
        lastLogin: DateTime.now(),
        owner: loginResponse['owner'] ?? '',
        creation: loginResponse['creation'] ?? '',
        modified: loginResponse['modified'] ?? '',
        modifiedBy: loginResponse['modified_by'] ?? '',
        docstatus: loginResponse['docstatus'] ?? 0,
      );

      await _storage.storeUser(user);
      
      return user;
    } on FrappeException {
      rethrow;
    } catch (e) {
      throw FrappeException.authentication('Login failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _authApi.logout();
    } catch (e) {
      print('Logout API call failed: $e');
    } finally {
      await _storage.clearAllData();
    }
  }

  Future<bool> isUserLoggedIn() async {
    try {
      return await _storage.isUserLoggedIn();
    } catch (e) {
      return false;
    }
  }

  Future<FrappeUser?> getCurrentUser() async {
    try {
      return await _storage.getUser();
    } catch (e) {
      throw FrappeException.storage('Failed to get current user: $e');
    }
  }

  Future<FrappeUser?> refreshUser() async {
    try {
      if (!await isUserLoggedIn()) {
        return null;
      }

      final currentUser = await getCurrentUser();
      final userInfo = await _authApi.getUserDetails(currentUser?.name ?? '');

      if (currentUser != null) {
        final updatedUser = currentUser.copyWith(
          name: userInfo['name'] ?? currentUser.name,
          email: userInfo['email'] ?? currentUser.email,
          fullName: userInfo['full_name'] ?? currentUser.fullName,
          username: userInfo['username'] ?? currentUser.username,
          firstName: userInfo['first_name'] ?? currentUser.firstName,
          lastName: userInfo['last_name'] ?? currentUser.lastName,
          timeZone: userInfo['time_zone'] ?? currentUser.timeZone,
          userType: userInfo['user_type'] ?? currentUser.userType,
          lastIp: userInfo['last_ip'] ?? currentUser.lastIp,
          roles: _parseRoles(userInfo['roles'] ?? []),
          roleProfiles: List<String>.from(userInfo['role_profiles'] ?? currentUser.roleProfiles),
          lastLogin: DateTime.now(),
          owner: userInfo['owner'] ?? currentUser.owner,
          creation: userInfo['creation'] ?? currentUser.creation,
          modified: userInfo['modified'] ?? currentUser.modified,
          modifiedBy: userInfo['modified_by'] ?? currentUser.modifiedBy,
          docstatus: userInfo['docstatus'] ?? currentUser.docstatus,
        );

        await _storage.storeUser(updatedUser);
        return updatedUser;
      }

      return null;
    } on FrappeException catch (e) {
      if (e.requiresAuth) {
        await _storage.clearAllData();
        return null;
      }
      return await getCurrentUser();
    } catch (e) {
      return await getCurrentUser();
    }
  }

  Future<bool> hasRole(String role) async {
    try {
      final user = await getCurrentUser();
      return user?.roleNames.contains(role) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> hasAnyRole(List<String> roles) async {
    try {
      final user = await getCurrentUser();
      if (user == null) return false;
      
      return roles.any((role) => user.roleNames.contains(role));
    } catch (e) {
      return false;
    }
  }

  List<FrappeUserRole> _parseRoles(List<dynamic> rolesData) {
    return rolesData.map((role) => FrappeUserRole.fromJson(role)).toList();
  }
}