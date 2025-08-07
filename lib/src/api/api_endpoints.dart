class ApiEndpoints {
  ApiEndpoints._();

  // Base paths
  static const String _apiBase = '/api';
  static const String _methodBase = '$_apiBase/method';
  static const String _resourceBase = '$_apiBase/resource';

  // Authentication endpoints
  static const String login = '$_methodBase/checktrack_connector.auth.mobile_login';
  static const String logout = '$_methodBase/logout';
  static const String getUserDetails = '$_resourceBase/User/{user_id}';

  // Form endpoints
  static const String getForm = '$_resourceBase/{doctype}/{name}';
  static const String saveForm = '$_resourceBase/{doctype}';
  static const String updateForm = '$_resourceBase/{doctype}/{name}';
  static const String deleteForm = '$_resourceBase/{doctype}/{name}';
  static const String getFormMeta = '$_methodBase/frappe.desk.form.load.getdoc';
  static const String getFormList = '$_methodBase/frappe.desk.reportview.get';

  // Utility methods
  static String getFormEndpoint(String doctype, [String? name]) {
    if (name != null) {
      return getForm.replaceAll('{doctype}', doctype).replaceAll('{name}', name);
    }
    return saveForm.replaceAll('{doctype}', doctype);
  }

  static String getUpdateFormEndpoint(String doctype, String name) {
    return updateForm.replaceAll('{doctype}', doctype).replaceAll('{name}', name);
  }

  static String getDeleteFormEndpoint(String doctype, String name) {
    return deleteForm.replaceAll('{doctype}', doctype).replaceAll('{name}', name);
  }

  static String getUserDetailsEndpoint(String userId) {
    return getUserDetails.replaceAll('{user_id}', userId);
  }
}