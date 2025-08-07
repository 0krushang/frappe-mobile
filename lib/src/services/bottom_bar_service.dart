import '../../frappe_mobile.dart';

class BottomBarService {
  static final BottomBarService _instance = BottomBarService._internal();
  factory BottomBarService() => _instance;
  BottomBarService._internal();

  final BottomBarApiService _bottomBarApi = BottomBarApiService();
  final StorageService _storage = StorageService();

  Future<List<BottomBarItem>> getBottomBarConfig(String role) async {
    try {
      if (role.isEmpty ) {
        throw FrappeException.configuration('Please define appropiate role.');
      }

      final bottomBarResponse = await _bottomBarApi.fetchBottomBarConfig(role);

      await _storage.cacheData(FrappeConstants.bottomBarConfigKey, bottomBarResponse);

      return bottomBarResponse;
    } on FrappeException {
      rethrow;
    } catch (e) {
      throw FrappeException.authentication('Login failed: $e');
    }
  }
}
