// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:frappe_mobile/frappe_mobile.dart';
import 'package:frappe_mobile/src/models/user/frappe_user.dart';
import 'package:frappe_mobile/src/utils/exceptions.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('FrappeMobile Package Tests', () {
    setUp(() async {
      // Clear any existing data before each test
      await FrappeMobile.storage.clearAllData();
    });

    tearDown(() async {
      // Clean up after each test
      await FrappeMobile.storage.clearAllData();
    });

    group('Initialization Tests', () {
      test('should initialize without errors with valid URL', () async {
        expect(() async {
          await FrappeMobile.initialize(siteUrl: 'https://test.example.com');
        }, returnsNormally);
      });

      test('should format URL correctly when missing protocol', () async {
        await FrappeMobile.initialize(siteUrl: 'test.example.com');
        final siteUrl = await FrappeMobile.getSiteUrl();
        expect(siteUrl, equals('https://test.example.com'));
      });

      test('should format URL correctly when ending with slash', () async {
        await FrappeMobile.initialize(siteUrl: 'https://test.example.com/');
        final siteUrl = await FrappeMobile.getSiteUrl();
        expect(siteUrl, equals('https://test.example.com'));
      });

      test('should handle HTTP URLs correctly', () async {
        await FrappeMobile.initialize(siteUrl: 'http://test.example.com');
        final siteUrl = await FrappeMobile.getSiteUrl();
        expect(siteUrl, equals('http://test.example.com'));
      });
    });

    group('Authentication State Tests', () {
      test('should return false when user is not logged in', () async {
        final isLoggedIn = await FrappeMobile.isLoggedIn();
        expect(isLoggedIn, isFalse);
      });

      test('should have proper class structure', () {
        expect(FrappeMobile, isNotNull);
        expect(FrappeMobile.auth, isNotNull);
        expect(FrappeMobile.storage, isNotNull);
      });

      test('should provide authentication methods', () {
        expect(FrappeMobile.login, isNotNull);
        expect(FrappeMobile.logout, isNotNull);
        expect(FrappeMobile.isLoggedIn, isNotNull);
      });
    });

    group('Singleton Pattern Tests', () {
      test('should maintain singleton instance', () {
        final instance1 = FrappeMobile();
        final instance2 = FrappeMobile();
        expect(identical(instance1, instance2), isTrue);
      });

      test('should maintain singleton auth instance', () {
        final auth1 = FrappeMobile.auth;
        final auth2 = FrappeMobile.auth;
        expect(identical(auth1, auth2), isTrue);
      });

      test('should maintain singleton storage instance', () {
        final storage1 = FrappeMobile.storage;
        final storage2 = FrappeMobile.storage;
        expect(identical(storage1, storage2), isTrue);
      });
    });

    group('Error Handling Tests', () {
      test('should handle initialization with empty URL', () async {
        expect(() async {
          await FrappeMobile.initialize(siteUrl: '');
        }, throwsA(isA<Exception>()));
      });

      test('should handle initialization with invalid URL', () async {
        expect(() async {
          await FrappeMobile.initialize(siteUrl: 'invalid-url');
        }, returnsNormally); // Should still format and store
      });
    });
  });
}
