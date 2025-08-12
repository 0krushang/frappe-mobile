import 'constants.dart';

enum FrappeExceptionType {
  network,
  server,
  authentication,
  authorization,
  validation,
  configuration,
  storage,
  invalidRequest,
  notFound,
  cancelled,
  unknown,
}

class FrappeException implements Exception {
  final String message;
  final FrappeExceptionType type;
  final int? statusCode;
  final dynamic responseData;
  final StackTrace? stackTrace;

  const FrappeException({
    required this.message,
    required this.type,
    this.statusCode,
    this.responseData,
    this.stackTrace,
  });

  factory FrappeException.authentication(String message) {
    return FrappeException(
      message: message,
      type: FrappeExceptionType.authentication,
      statusCode: 401,
    );
  }

  factory FrappeException.authorization(String message) {
    return FrappeException(
      message: message,
      type: FrappeExceptionType.authorization,
      statusCode: 403,
    );
  }

  factory FrappeException.network(String message) {
    return FrappeException(
      message: message,
      type: FrappeExceptionType.network,
    );
  }

  factory FrappeException.server(String message, {int? statusCode, dynamic responseData}) {
    return FrappeException(
      message: message,
      type: FrappeExceptionType.server,
      statusCode: statusCode,
      responseData: responseData,
    );
  }

  factory FrappeException.validation(String message, {dynamic responseData}) {
    return FrappeException(
      message: message,
      type: FrappeExceptionType.validation,
      statusCode: 422,
      responseData: responseData,
    );
  }

  factory FrappeException.configuration(String message) {
    return FrappeException(
      message: message,
      type: FrappeExceptionType.configuration,
    );
  }

  factory FrappeException.storage(String message) {
    return FrappeException(
      message: message,
      type: FrappeExceptionType.storage,
    );
  }

  factory FrappeException.notFound(String message) {
    return FrappeException(
      message: message,
      type: FrappeExceptionType.notFound,
      statusCode: 404,
    );
  }

  bool get isRecoverable {
    switch (type) {
      case FrappeExceptionType.network:
      case FrappeExceptionType.server:
        return statusCode != null && statusCode! >= 500;
      case FrappeExceptionType.cancelled:
        return true;
      default:
        return false;
    }
  }

  bool get requiresAuth {
    return type == FrappeExceptionType.authentication || statusCode == 401;
  }

  String get userMessage {
    switch (type) {
      case FrappeExceptionType.network:
        return FrappeConstants.networkUserMessage;
      case FrappeExceptionType.authentication:
        return FrappeConstants.authenticationUserMessage;
      case FrappeExceptionType.authorization:
        return FrappeConstants.authorizationUserMessage;
      case FrappeExceptionType.validation:
        return FrappeConstants.validationUserMessage;
      case FrappeExceptionType.notFound:
        return FrappeConstants.notFoundUserMessage;
      case FrappeExceptionType.server:
        if (statusCode != null && statusCode! >= 500) {
          return FrappeConstants.serverUserMessage;
        }
        return message;
      case FrappeExceptionType.cancelled:
        return FrappeConstants.cancelledUserMessage;
      case FrappeExceptionType.configuration:
        return FrappeConstants.configurationUserMessage;
      case FrappeExceptionType.storage:
        return FrappeConstants.storageUserMessage;
      default:
        return FrappeConstants.unknownUserMessage;
    }
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('FrappeException: $message');
    
    if (statusCode != null) {
      buffer.write(' (Status: $statusCode)');
    }
    
    buffer.write(' (Type: ${type.name})');
    
    if (responseData != null) {
      buffer.write(' (Data: $responseData)');
    }
    
    return buffer.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'type': type.name,
      'statusCode': statusCode,
      'responseData': responseData,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}