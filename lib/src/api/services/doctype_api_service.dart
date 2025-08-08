import 'package:frappe_mobile/frappe_mobile.dart';

class DoctypeApiService {
  static final DoctypeApiService _instance = DoctypeApiService._internal();
  factory DoctypeApiService() => _instance;
  DoctypeApiService._internal();

  final ApiClient _client = ApiClient();

  Future<Map<String, dynamic>> getDoctypeMetaData({
    required String doctype
  }) async {
    try {
      final response = await _client.post(
        ApiEndpoints.getDoctypeMetadata(doctype),
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
}