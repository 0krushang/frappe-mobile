import 'package:dio/dio.dart';
import '../../services/storage_service.dart';
import '../../utils/constants.dart';


class ApiInterceptor extends Interceptor {
  final StorageService _storage = StorageService();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      if (options.extra['includeAuth'] == true) {
        final user = await _storage.getUser();
        if (user != null && user.apiKey.isNotEmpty && user.apiSecret.isNotEmpty) {
          options.headers['Authorization'] = 'token ${user.apiKey}:${user.apiSecret}';
        }
      }

      options.headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': FrappeConstants.userAgent,
      });

      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          message: 'Failed to prepare request: $e',
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {

    DioException modifiedError = err;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        modifiedError = DioException(
          requestOptions: err.requestOptions,
          message: FrappeConstants.networkTimeoutError,
          type: err.type,
        );
        break;

      case DioExceptionType.connectionError:
        modifiedError = DioException(
          requestOptions: err.requestOptions,
          message: FrappeConstants.networkError,
          type: err.type,
        );
        break;

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        String errorMessage = _getErrorMessage(err.response);

        switch (statusCode) {
          case 401:
            errorMessage = FrappeConstants.unauthorizedError;
            break;
          case 403:
            errorMessage = FrappeConstants.forbiddenError;
            break;
          case 404:
            errorMessage = FrappeConstants.notFoundError;
            break;
          case 429:
            errorMessage = FrappeConstants.rateLimitError;
            break;
          case 500:
            errorMessage = FrappeConstants.serverError;
            break;
        }

        modifiedError = DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          message: errorMessage,
          type: err.type,
        );
        break;

      case DioExceptionType.cancel:
        modifiedError = DioException(
          requestOptions: err.requestOptions,
          message: FrappeConstants.requestCancelledError,
          type: err.type,
        );
        break;

      default:
        modifiedError = DioException(
          requestOptions: err.requestOptions,
          message: err.message ?? FrappeConstants.unknownError,
          type: err.type,
        );
    }

    handler.next(modifiedError);
  }

  String _getErrorMessage(Response? response) {
    if (response?.data is Map<String, dynamic>) {
      final data = response!.data as Map<String, dynamic>;
      
      if (data['message'] != null) {
        return data['message'].toString();
      }
      if (data['error'] != null) {
        return data['error'].toString();
      }
      if (data['exc'] != null) {
        return data['exc'].toString();
      }
      if (data['_server_messages'] != null) {
        return data['_server_messages'].toString();
      }
    }
    
    return 'An error occurred while processing the request';
  }
}