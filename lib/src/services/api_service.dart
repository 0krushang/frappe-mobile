import 'dart:io';
import 'package:dio/dio.dart';
import '../utils/constants.dart';
import 'storage_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final StorageService _storage = StorageService();
  Dio? _dio;

  // Initialize Dio
  Future<void> initializeDio() async {
    final siteUrl = await _storage.getSiteUrl();
    
    _dio = Dio(BaseOptions(
      baseUrl: siteUrl ?? '',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      responseType: ResponseType.json,
    ));

    // Add interceptors
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if needed
          if (options.extra['includeAuth'] == true) {
            final user = await _storage.getUser();
            if (user != null && user.apiKey.isNotEmpty && user.apiSecret.isNotEmpty) {
              options.headers['Authorization'] = 'token ${user.apiKey}:${user.apiSecret}';
            }
          }
          handler.next(options);
        },
        onError: (error, handler) {
          // Handle common errors
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout) {
            error = DioException(
              requestOptions: error.requestOptions,
              message: FrappeConstants.networkError,
            );
          }
          handler.next(error);
        },
      ),
    );

    // Add logging interceptor in debug mode
    _dio!.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print(obj),
    ));
  }

  // Ensure Dio is initialized
  Future<Dio> _getDio() async {
    if (_dio == null) {
      await initializeDio();
    } else {
      // Update base URL if changed
      final siteUrl = await _storage.getSiteUrl();
      if (_dio!.options.baseUrl != siteUrl) {
        _dio!.options.baseUrl = siteUrl ?? '';
      }
    }
    return _dio!;
  }

  // Login API call
  Future<Map<String, dynamic>> login(String username, String password) async {
    final siteUrl = await _storage.getSiteUrl();
    if (siteUrl == null) {
      throw Exception(FrappeConstants.noSiteUrlError);
    }

    try {
      final dio = await _getDio();
      final response = await dio.post(
        FrappeConstants.loginEndpoint,
        data: {
          'usr': username,
          'pwd': password,
        },
        options: Options(extra: {'includeAuth': false}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['message'] != null) {
          return data['message'];
        } else {
          throw Exception(FrappeConstants.loginFailedError);
        }
      } else {
        throw Exception('Login failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw Exception(FrappeConstants.networkError);
      }
      throw Exception('Login failed: ${e.message}');
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Logout API call
  Future<void> logout() async {
    final siteUrl = await _storage.getSiteUrl();
    if (siteUrl == null) return;

    try {
      final dio = await _getDio();
      await dio.post(
        FrappeConstants.logoutEndpoint,
        options: Options(extra: {'includeAuth': true}),
      );
    } catch (e) {
      // Ignore logout errors, we'll clear local data anyway
    }
  }

  // Get user info
  Future<Map<String, dynamic>> getUserInfo() async {
    final siteUrl = await _storage.getSiteUrl();
    if (siteUrl == null) {
      throw Exception(FrappeConstants.noSiteUrlError);
    }

    try {
      final dio = await _getDio();
      final response = await dio.get(
        FrappeConstants.userInfoEndpoint,
        options: Options(extra: {'includeAuth': true}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return data['message'] ?? data;
      } else {
        throw Exception('Failed to get user info: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to get user info: ${e.message}');
    }
  }

  // Generic API call method
  Future<Response> makeApiCall({
    required String endpoint,
    required String method,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool includeAuth = true,
    Options? options,
  }) async {
    final siteUrl = await _storage.getSiteUrl();
    if (siteUrl == null) {
      throw Exception(FrappeConstants.noSiteUrlError);
    }

    try {
      final dio = await _getDio();
      
      // Merge options
      final requestOptions = options?.copyWith(
        extra: {...(options.extra ?? {}), 'includeAuth': includeAuth},
      ) ?? Options(
        extra: {'includeAuth': includeAuth},
      );

      switch (method.toUpperCase()) {
        case 'GET':
          return await dio.get(
            endpoint,
            queryParameters: queryParameters,
            options: requestOptions,
          );
        case 'POST':
          return await dio.post(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: requestOptions,
          );
        case 'PUT':
          return await dio.put(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: requestOptions,
          );
        case 'DELETE':
          return await dio.delete(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: requestOptions,
          );
        case 'PATCH':
          return await dio.patch(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: requestOptions,
          );
        default:
          throw Exception('Unsupported HTTP method: $method');
      }
    } on DioException catch (e) {
      throw Exception('API call failed: ${e.message}');
    }
  }

  // File upload method
  Future<Response> uploadFile({
    required String endpoint,
    required File file,
    String fileFieldName = 'file',
    Map<String, dynamic>? additionalData,
    bool includeAuth = true,
    void Function(int, int)? onSendProgress,
  }) async {
    final siteUrl = await _storage.getSiteUrl();
    if (siteUrl == null) {
      throw Exception(FrappeConstants.noSiteUrlError);
    }

    try {
      final dio = await _getDio();
      
      final formData = FormData();
      
      // Add file
      formData.files.add(
        MapEntry(
          fileFieldName,
          await MultipartFile.fromFile(file.path),
        ),
      );
      
      // Add additional data
      if (additionalData != null) {
        additionalData.forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });
      }

      return await dio.post(
        endpoint,
        data: formData,
        options: Options(
          extra: {'includeAuth': includeAuth},
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
        onSendProgress: onSendProgress,
      );
    } on DioException catch (e) {
      throw Exception('File upload failed: ${e.message}');
    }
  }

  // Download file method
  Future<Response> downloadFile({
    required String endpoint,
    required String savePath,
    bool includeAuth = true,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final siteUrl = await _storage.getSiteUrl();
    if (siteUrl == null) {
      throw Exception(FrappeConstants.noSiteUrlError);
    }

    try {
      final dio = await _getDio();
      
      return await dio.download(
        endpoint,
        savePath,
        options: Options(
          extra: {'includeAuth': includeAuth},
        ),
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw Exception('File download failed: ${e.message}');
    }
  }
}