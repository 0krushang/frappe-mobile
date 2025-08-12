import 'package:dio/dio.dart';

class FrappeConstants {
  FrappeConstants._();

  // Storage keys
  static const String userStorageKey = 'frappe_user_data';
  static const String siteUrlKey = 'frappe_site_url';
  static const String isLoggedInKey = 'frappe_is_logged_in';
  static const String appConfigKey = 'frappe_app_config';
  static const String lastSyncKey = 'frappe_last_sync';
  static const String bottomBarConfigKey = 'bottom_bar_config';

  // Package info
  static const String packageVersion = '1.0.0';
  static const String userAgent = 'FrappeMobile/$packageVersion';

  // Timeouts (in seconds)
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;

  // Retry configuration
  static const int maxRetryAttempts = 3;
  static const int retryDelaySeconds = 2;

  // Dio configuration
  static const bool followRedirects = true;
  static const int maxRedirects = 3;
  static const ResponseType responseType = ResponseType.json;

  // HTTP Status Codes
  static const int statusOk = 200;
  static const int statusCreated = 201;
  static const int statusNoContent = 204;
  static const int statusBadRequest = 400;
  static const int statusUnauthorized = 401;
  static const int statusForbidden = 403;
  static const int statusNotFound = 404;
  static const int statusUnprocessableEntity = 422;
  static const int statusTooManyRequests = 429;
  static const int statusInternalServerError = 500;
  static const int statusBadGateway = 502;
  static const int statusServiceUnavailable = 503;

  // HTTP Methods
  static const String httpGet = 'GET';
  static const String httpPost = 'POST';
  static const String httpPut = 'PUT';
  static const String httpDelete = 'DELETE';
  static const String httpPatch = 'PATCH';

  // API Options Keys
  static const String includeAuthKey = 'includeAuth';

  // Error Messages - Network
  static const String networkError = 'Network error. Please check your internet connection.';
  static const String networkTimeoutError = 'Request timed out. Please try again.';
  static const String requestCancelledError = 'Request was cancelled.';

  // Error Messages - Authentication
  static const String noSiteUrlError = 'Site URL not configured. Please call FrappeMobile.initialize() first.';
  static const String unauthorizedError = 'Authentication failed. Please log in again.';
  static const String forbiddenError = 'You don\'t have permission to access this resource.';

  // Error Messages - Server
  static const String serverError = 'Server error. Please try again later.';
  static const String notFoundError = 'Requested resource not found.';
  static const String rateLimitError = 'Too many requests. Please wait before trying again.';
  static const String serverResponseError = 'Server responded with an error';

  // Error Messages - General
  static const String unknownError = 'An unexpected error occurred. Please try again.';
  static const String unsupportedMethodError = 'Unsupported HTTP method: ';
  static const String unexpectedError = 'Unexpected error: ';

  // User-friendly error messages for exceptions
  static const String networkUserMessage = 'Please check your internet connection and try again.';
  static const String authenticationUserMessage = 'Please log in again to continue.';
  static const String authorizationUserMessage = 'You don\'t have permission to perform this action.';
  static const String validationUserMessage = 'Please check your input and try again.';
  static const String notFoundUserMessage = 'The requested resource was not found.';
  static const String serverUserMessage = 'Server is temporarily unavailable. Please try again later.';
  static const String cancelledUserMessage = 'Request was cancelled.';
  static const String configurationUserMessage = 'App configuration error. Please contact support.';
  static const String storageUserMessage = 'Local storage error. Please try again.';
  static const String unknownUserMessage = 'An unexpected error occurred. Please try again.';
}