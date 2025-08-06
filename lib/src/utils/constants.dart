class FrappeConstants {
  static const String userStorageKey = 'frappe_user_data';
  static const String siteUrlKey = 'frappe_site_url';
  static const String isLoggedInKey = 'frappe_is_logged_in';
  
  // API Endpoints
  static const String loginEndpoint = '/api/method/checktrack_connector.auth.mobile_login';
  static const String logoutEndpoint = '/api/method/logout';
  static const String userInfoEndpoint = '/api/method/frappe.auth.get_logged_user';
  
  // Error Messages
  static const String noSiteUrlError = 'Site URL not configured. Call FrappeMobile.setUrl() first.';
  static const String loginFailedError = 'Login failed. Please check credentials.';
  static const String networkError = 'Network error. Please check your connection.';
}