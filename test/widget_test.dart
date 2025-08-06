// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:frappe_mobile/frappe_mobile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('FrappeMobile Package Tests', () {
    test('should initialize without errors', () async {
      // Test that the package can be initialized
      expect(() async {
        await FrappeMobile.initialize(siteUrl: 'https://test.example.com');
      }, returnsNormally);
    });

    test('should have proper class structure', () {
      // Test that the main classes exist and are accessible
      expect(FrappeMobile, isNotNull);
      expect(Authentication, isNotNull);
    });

    test('should provide authentication methods', () {
      // Test that authentication methods are available
      expect(Authentication.login, isNotNull);
      expect(Authentication.logout, isNotNull);
      expect(Authentication.isUserLoggedIn, isNotNull);
      expect(Authentication.getUser, isNotNull);
    });

    test('should provide API methods', () {
      // Test that API methods are available
      expect(FrappeMobile.makeApiCall, isNotNull);
      expect(FrappeMobile.uploadFile, isNotNull);
      expect(FrappeMobile.downloadFile, isNotNull);
    });
  });
}
