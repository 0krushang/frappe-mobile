import 'package:flutter_test/flutter_test.dart';
import 'package:frappe_mobile/frappe_mobile.dart';
import 'package:frappe_mobile/src/models/user/frappe_user.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FrappeStorage Tests', () {
    setUp(() async {
      // Clear any existing data before each test
      await FrappeMobile.storage.clearAllData();
    });

    tearDown(() async {
      // Clean up after each test
      await FrappeMobile.storage.clearAllData();
    });

    group('Site URL Storage Tests', () {
      test('should store and retrieve site URL', () async {
        const testUrl = 'https://test.example.com';
        
        await FrappeMobile.storage.storeSiteUrl(testUrl);
        final retrievedUrl = await FrappeMobile.storage.getSiteUrl();
        
        expect(retrievedUrl, equals(testUrl));
      });

      test('should return null when site URL is not stored', () async {
        final retrievedUrl = await FrappeMobile.storage.getSiteUrl();
        expect(retrievedUrl, isNull);
      });

      test('should update existing site URL', () async {
        const initialUrl = 'https://initial.example.com';
        const updatedUrl = 'https://updated.example.com';
        
        await FrappeMobile.storage.storeSiteUrl(initialUrl);
        await FrappeMobile.storage.storeSiteUrl(updatedUrl);
        
        final retrievedUrl = await FrappeMobile.storage.getSiteUrl();
        expect(retrievedUrl, equals(updatedUrl));
      });
    });

    group('User Storage Tests', () {
      test('should store and retrieve user data', () async {
        final testUser = FrappeUser(
          name: 'testuser',
          email: 'test@example.com',
          fullName: 'Test User',
          apiKey: 'test-api-key',
          apiSecret: 'test-api-secret',
          username: 'testuser',
          firstName: 'Test',
          lastName: 'User',
          timeZone: 'UTC',
          userType: 'System User',
          lastIp: '127.0.0.1',
          owner: 'testuser',
          creation: '2024-01-01',
          modified: '2024-01-01',
          modifiedBy: 'testuser',
          docstatus: 0,
        );

        await FrappeMobile.storage.storeUser(testUser);
        final retrievedUser = await FrappeMobile.storage.getUser();

        expect(retrievedUser, isNotNull);
        expect(retrievedUser!.name, equals(testUser.name));
        expect(retrievedUser.email, equals(testUser.email));
        expect(retrievedUser.fullName, equals(testUser.fullName));
      });

      test('should return null when user is not stored', () async {
        final retrievedUser = await FrappeMobile.storage.getUser();
        expect(retrievedUser, isNull);
      });

      test('should check if user is logged in correctly', () async {
        // Initially not logged in
        expect(await FrappeMobile.storage.isUserLoggedIn(), isFalse);

        // Store a user
        final testUser = FrappeUser(
          name: 'testuser',
          email: 'test@example.com',
          fullName: 'Test User',
          apiKey: 'test-api-key',
          apiSecret: 'test-api-secret',
          username: 'testuser',
          firstName: 'Test',
          lastName: 'User',
          timeZone: 'UTC',
          userType: 'System User',
          lastIp: '127.0.0.1',
          owner: 'testuser',
          creation: '2024-01-01',
          modified: '2024-01-01',
          modifiedBy: 'testuser',
          docstatus: 0,
        );

        await FrappeMobile.storage.storeUser(testUser);
        expect(await FrappeMobile.storage.isUserLoggedIn(), isTrue);
      });

      test('should clear user data correctly', () async {
        final testUser = FrappeUser(
          name: 'testuser',
          email: 'test@example.com',
          fullName: 'Test User',
          apiKey: 'test-api-key',
          apiSecret: 'test-api-secret',
          username: 'testuser',
          firstName: 'Test',
          lastName: 'User',
          timeZone: 'UTC',
          userType: 'System User',
          lastIp: '127.0.0.1',
          owner: 'testuser',
          creation: '2024-01-01',
          modified: '2024-01-01',
          modifiedBy: 'testuser',
          docstatus: 0,
        );

        await FrappeMobile.storage.storeUser(testUser);
        expect(await FrappeMobile.storage.isUserLoggedIn(), isTrue);

        await FrappeMobile.storage.clearAllData();
        expect(await FrappeMobile.storage.isUserLoggedIn(), isFalse);
        expect(await FrappeMobile.storage.getUser(), isNull);
      });
    });

    group('Generic Storage Tests', () {
      test('should store and retrieve string data', () async {
        const testKey = 'test_string_key';
        const testValue = 'test-string-value';
        
        await FrappeMobile.storage.storeString(testKey, testValue);
        final retrievedValue = await FrappeMobile.storage.getString(testKey);
        
        expect(retrievedValue, equals(testValue));
      });

      test('should return null when string is not stored', () async {
        final retrievedValue = await FrappeMobile.storage.getString('non_existent_key');
        expect(retrievedValue, isNull);
      });

      test('should store and retrieve boolean data', () async {
        const testKey = 'test_bool_key';
        const testValue = true;
        
        await FrappeMobile.storage.storeBool(testKey, testValue);
        final retrievedValue = await FrappeMobile.storage.getBool(testKey);
        
        expect(retrievedValue, equals(testValue));
      });

      test('should store and retrieve integer data', () async {
        const testKey = 'test_int_key';
        const testValue = 42;
        
        await FrappeMobile.storage.storeInt(testKey, testValue);
        final retrievedValue = await FrappeMobile.storage.getInt(testKey);
        
        expect(retrievedValue, equals(testValue));
      });

      test('should store and retrieve JSON data', () async {
        const testKey = 'test_json_key';
        final testValue = {'name': 'test', 'value': 123};
        
        await FrappeMobile.storage.storeJson(testKey, testValue);
        final retrievedValue = await FrappeMobile.storage.getJson(testKey);
        
        expect(retrievedValue, equals(testValue));
      });

      test('should store and retrieve secure string data', () async {
        const testKey = 'test_secure_key';
        const testValue = 'secure-test-value';
        
        await FrappeMobile.storage.storeSecureString(testKey, testValue);
        final retrievedValue = await FrappeMobile.storage.getSecureString(testKey);
        
        expect(retrievedValue, equals(testValue));
      });

      test('should remove specific data', () async {
        const testKey = 'test_remove_key';
        const testValue = 'test-value';
        
        await FrappeMobile.storage.storeString(testKey, testValue);
        expect(await FrappeMobile.storage.getString(testKey), equals(testValue));
        
        await FrappeMobile.storage.removeData(testKey);
        expect(await FrappeMobile.storage.getString(testKey), isNull);
      });
    });

    group('Data Clearing Tests', () {
      test('should clear all data correctly', () async {
        // Store various data
        await FrappeMobile.storage.storeSiteUrl('https://test.example.com');
        await FrappeMobile.storage.storeString('test_key', 'test-value');
        
        final testUser = FrappeUser(
          name: 'testuser',
          email: 'test@example.com',
          fullName: 'Test User',
          apiKey: 'test-api-key',
          apiSecret: 'test-api-secret',
          username: 'testuser',
          firstName: 'Test',
          lastName: 'User',
          timeZone: 'UTC',
          userType: 'System User',
          lastIp: '127.0.0.1',
          owner: 'testuser',
          creation: '2024-01-01',
          modified: '2024-01-01',
          modifiedBy: 'testuser',
          docstatus: 0,
        );
        await FrappeMobile.storage.storeUser(testUser);

        // Verify data exists
        expect(await FrappeMobile.storage.getSiteUrl(), isNotNull);
        expect(await FrappeMobile.storage.getString('test_key'), isNotNull);
        expect(await FrappeMobile.storage.getUser(), isNotNull);

        // Clear all data
        await FrappeMobile.storage.clearAllData();

        // Verify all data is cleared
        expect(await FrappeMobile.storage.getSiteUrl(), isNull);
        expect(await FrappeMobile.storage.getString('test_key'), isNull);
        expect(await FrappeMobile.storage.getUser(), isNull);
        expect(await FrappeMobile.storage.isUserLoggedIn(), isFalse);
      });
    });

    group('Singleton Pattern Tests', () {
      test('should maintain singleton instance', () {
        final storage1 = FrappeMobile.storage;
        final storage2 = FrappeMobile.storage;
        expect(identical(storage1, storage2), isTrue);
      });
    });
  });
} 