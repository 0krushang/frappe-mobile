import 'package:frappe_mobile/src/api/client/api_client.dart';
import 'package:frappe_mobile/src/models/user/frappe_user.dart';
import 'package:frappe_mobile/src/services/storage_service.dart';

import 'features/frappe_auth.dart';
import 'features/frappe_storage.dart';


class FrappeMobile {
  static final FrappeMobile _instance = FrappeMobile._internal();
  factory FrappeMobile() => _instance;
  FrappeMobile._internal();

  static final FrappeAuth auth = FrappeAuth();
  static final FrappeStorage storage = FrappeStorage();

  static Future<void> initialize({required String siteUrl}) async {
    String formattedUrl = siteUrl;
    
    if (formattedUrl.endsWith('/')) {
      formattedUrl = formattedUrl.substring(0, formattedUrl.length - 1);
    }
    
    if (!formattedUrl.startsWith('http://') && !formattedUrl.startsWith('https://')) {
      formattedUrl = 'https://$formattedUrl';
    }
    
    await StorageService().storeSiteUrl(formattedUrl);
    
    await ApiClient().initialize();
  }

  static Future<String?> getSiteUrl() async {
    return await StorageService().getSiteUrl();
  }

  static Future<FrappeUser> login(String username, String password) async {
    return await auth.login(username, password);
  }

  static Future<void> logout() async {
    await auth.logout();
  }

  static Future<bool> isLoggedIn() async {
    return await auth.isUserLoggedIn();
  }
}