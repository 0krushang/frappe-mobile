import 'package:frappe_mobile/src/services/authentication_service.dart';
import '../../models/user/frappe_user.dart';


class FrappeAuth {
  static final FrappeAuth _instance = FrappeAuth._internal();
  factory FrappeAuth() => _instance;
  FrappeAuth._internal();

  Future<FrappeUser> login(String username, String password) async {
    return await AuthenticationService().login(username, password);
  }

  Future<void> logout() async {
    await AuthenticationService().logout();
  }

  Future<bool> isUserLoggedIn() async {
    return await AuthenticationService().isUserLoggedIn();
  }

  Future<FrappeUser?> getCurrentUser() async {
    return await AuthenticationService().getCurrentUser();
  }

  Future<FrappeUser?> refreshUser() async {
    return await AuthenticationService().refreshUser();
  }
}