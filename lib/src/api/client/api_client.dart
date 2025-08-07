import 'package:dio/dio.dart';
import '../../services/storage_service.dart';
import '../../utils/constants.dart';
import '../../utils/exceptions.dart';
import 'api_interceptor.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final StorageService _storage = StorageService();
  Dio? _dio;

  Future<void> initialize() async {
    final siteUrl = await _storage.getSiteUrl();
    
    if (siteUrl == null) {
      throw FrappeException(
        message: FrappeConstants.noSiteUrlError,
        type: FrappeExceptionType.configuration,
      );
    }

    _dio = Dio(BaseOptions(
      baseUrl: siteUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      responseType: ResponseType.json,
      followRedirects: true,
      maxRedirects: 3,
    ));

    _dio!.interceptors.add(ApiInterceptor());
  }


  Future<Dio> _getDio() async {
    if (_dio == null) {
      await initialize();
    } else {
      final siteUrl = await _storage.getSiteUrl();
      if (_dio!.options.baseUrl != siteUrl) {
        _dio!.options.baseUrl = siteUrl ?? '';
      }
    }
    return _dio!;
  }

  Future<Response<T>> request<T>({
    required String endpoint,
    required String method,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool includeAuth = true,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final dio = await _getDio();
      
      final requestOptions = (options ?? Options()).copyWith(
        extra: {
          ...(options?.extra ?? {}),
          'includeAuth': includeAuth,
        },
      );

      Response<T> response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await dio.get<T>(
            endpoint,
            queryParameters: queryParameters,
            options: requestOptions,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress,
          );
          break;

        case 'POST':
          response = await dio.post<T>(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: requestOptions,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          );
          break;

        case 'PUT':
          response = await dio.put<T>(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: requestOptions,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          );
          break;

        case 'DELETE':
          response = await dio.delete<T>(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: requestOptions,
            cancelToken: cancelToken,
          );
          break;

        case 'PATCH':
          response = await dio.patch<T>(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: requestOptions,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          );
          break;

        default:
          throw FrappeException(
            message: 'Unsupported HTTP method: $method',
            type: FrappeExceptionType.invalidRequest,
          );
      }

      return response;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw FrappeException(
        message: 'Unexpected error: $e',
        type: FrappeExceptionType.unknown,
      );
    }
  }

  FrappeException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return FrappeException(
          message: e.message ?? FrappeConstants.networkTimeoutError,
          type: FrappeExceptionType.network,
          statusCode: e.response?.statusCode,
        );

      case DioExceptionType.connectionError:
        return FrappeException(
          message: e.message ?? FrappeConstants.networkError,
          type: FrappeExceptionType.network,
        );

      case DioExceptionType.badResponse:
        return FrappeException(
          message: e.message ?? 'Server responded with an error',
          type: FrappeExceptionType.server,
          statusCode: e.response?.statusCode,
          responseData: e.response?.data,
        );

      case DioExceptionType.cancel:
        return FrappeException(
          message: FrappeConstants.requestCancelledError,
          type: FrappeExceptionType.cancelled,
        );

      default:
        return FrappeException(
          message: e.message ?? FrappeConstants.unknownError,
          type: FrappeExceptionType.unknown,
        );
    }
  }

  void close() {
    _dio?.close();
    _dio = null;
  }

  Future<Response<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool includeAuth = true,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) {
    return request<T>(
      endpoint: endpoint,
      method: 'GET',
      queryParameters: queryParameters,
      options: options,
      includeAuth: includeAuth,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool includeAuth = true,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) {
    return request<T>(
      endpoint: endpoint,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      options: options,
      includeAuth: includeAuth,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool includeAuth = true,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) {
    return request<T>(
      endpoint: endpoint,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      options: options,
      includeAuth: includeAuth,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> delete<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool includeAuth = true,
    CancelToken? cancelToken,
  }) {
    return request<T>(
      endpoint: endpoint,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      options: options,
      includeAuth: includeAuth,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> patch<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool includeAuth = true,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) {
    return request<T>(
      endpoint: endpoint,
      method: 'PATCH',
      data: data,
      queryParameters: queryParameters,
      options: options,
      includeAuth: includeAuth,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }
}