class FrappeConstants {
  FrappeConstants._();

  // Storage keys
  static const String userStorageKey = 'frappe_user_data';
  static const String siteUrlKey = 'frappe_site_url';
  static const String isLoggedInKey = 'frappe_is_logged_in';
  static const String appConfigKey = 'frappe_app_config';
  static const String lastSyncKey = 'frappe_last_sync';


  static const String packageVersion = '1.0.0';
  static const String userAgent = 'FrappeMobile/$packageVersion';

  // Timeouts (in seconds)
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;

  // Retry configuration
  static const int maxRetryAttempts = 3;
  static const int retryDelaySeconds = 2;

  // Error Messages - Network
  static const String networkError = 'Network error. Please check your internet connection.';
  static const String networkTimeoutError = 'Request timed out. Please try again.';
  static const String requestCancelledError = 'Request was cancelled.';

  // Error Messages - Authentication
  static const String noSiteUrlError = 'Site URL not configured. Please call FrappeMobile.initialize() first.';
  static const String loginFailedError = 'Login failed. Please check your credentials.';
  static const String unauthorizedError = 'Authentication failed. Please log in again.';
  static const String forbiddenError = 'You don\'t have permission to access this resource.';
  static const String sessionExpiredError = 'Your session has expired. Please log in again.';

  // Error Messages - Server
  static const String serverError = 'Server error. Please try again later.';
  static const String notFoundError = 'Requested resource not found.';
  static const String rateLimitError = 'Too many requests. Please wait before trying again.';
  static const String validationError = 'Validation failed. Please check your input.';

  // Error Messages - General
  static const String unknownError = 'An unexpected error occurred. Please try again.';
  static const String configurationError = 'Configuration error. Please contact support.';
  static const String storageError = 'Local storage error. Please try again.';

  // Success Messages
  static const String loginSuccessMessage = 'Logged in successfully';
  static const String logoutSuccessMessage = 'Logged out successfully';
  static const String saveSuccessMessage = 'Saved successfully';
  static const String deleteSuccessMessage = 'Deleted successfully';
  static const String uploadSuccessMessage = 'File uploaded successfully';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxFieldLength = 255;
  static const List<String> supportedFileTypes = [
    'jpg', 'jpeg', 'png', 'gif', 'pdf', 'doc', 'docx', 'xls', 'xlsx'
  ];
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB

  // Cache settings
  static const Duration cacheExpiration = Duration(hours: 1);
  static const Duration userDataExpiration = Duration(days: 30);
  static const Duration configCacheExpiration = Duration(hours: 24);

  // Default values
  static const String defaultLanguage = 'en';
  static const String defaultTheme = 'light';
  static const int defaultPageSize = 20;

  // Form field types
  static const String fieldTypeData = 'Data';
  static const String fieldTypeTextEditor = 'Text Editor';
  static const String fieldTypeSelect = 'Select';
  static const String fieldTypeLink = 'Link';
  static const String fieldTypeInt = 'Int';
  static const String fieldTypeFloat = 'Float';
  static const String fieldTypeDate = 'Date';
  static const String fieldTypeDateTime = 'Datetime';
  static const String fieldTypeCheck = 'Check';
  static const String fieldTypeAttach = 'Attach';
  static const String fieldTypeAttachImage = 'Attach Image';
  static const String fieldTypeTable = 'Table';

  // Status values
  static const String statusDraft = 'Draft';
  static const String statusSubmitted = 'Submitted';
  static const String statusCancelled = 'Cancelled';

  // Date formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'dd MMM yyyy';
  static const String displayDateTimeFormat = 'dd MMM yyyy, hh:mm a';
}