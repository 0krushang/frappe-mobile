import 'package:frappe_mobile/frappe_mobile.dart';


class AuthApiService {
  static final AuthApiService _instance = AuthApiService._internal();
  factory AuthApiService() => _instance;
  AuthApiService._internal();

  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _client.post(
        ApiEndpoints.login,
        data: {
          'usr': username,
          'pwd': password,
        },
        includeAuth: false,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        if (data['message'] != null) {
          return Map<String, dynamic>.from(data['message']);
        } else {
          throw FrappeException.authentication('Invalid response format from server');
        }
      } else {
        throw FrappeException.authentication('Login failed with status: ${response.statusCode}');
      }
    } on FrappeException {
      rethrow;
    } catch (e) {
      throw FrappeException.authentication('Login failed: $e');
    }
  }


  Future<void> logout() async {
    try {
      await _client.post(
        ApiEndpoints.logout,
        includeAuth: true,
      );
    } catch (e) {
      // Logout failed - ignore non-auth errors as we clear local data anyway
    }
  }


  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    try {
      final response = await _client.get(
        ApiEndpoints.getUserDetailsEndpoint(userId),
        includeAuth: true,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        return data['data'] ?? data;
      } else {
        throw FrappeException.server(
          'Failed to get user details',
          statusCode: response.statusCode,
          responseData: response.data,
        );
      }
    } on FrappeException {
      rethrow;
    } catch (e) {
      throw FrappeException.server('Failed to get user details: $e');
    }
  }

}