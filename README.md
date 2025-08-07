# Frappe Mobile

A comprehensive Flutter package for integrating with Frappe Framework APIs. This package provides authentication, API calls, file upload/download, and user management functionality for building mobile applications that connect to Frappe/ERPNext backend systems.

## Features

- 🔐 **Authentication**: Login, logout, and session management
- 🌐 **API Integration**: Easy-to-use API client for Frappe Framework
- 📁 **File Operations**: Upload and download files with progress tracking
- 💾 **Secure Storage**: Encrypted local storage for sensitive data
- 🔄 **Session Management**: Automatic token refresh and session handling
- 📱 **Mobile Optimized**: Designed specifically for mobile applications

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  frappe_mobile: ^1.0.0
```

## Quick Start

### 1. Initialize the Package

```dart
import 'package:frappe_mobile/frappe_mobile.dart';

void main() async {
  // Initialize the package with your Frappe site URL
  await FrappeMobile.initialize(siteUrl: 'https://your-frappe-site.com');
  
  runApp(MyApp());
}
```

### 2. Authentication

```dart
// Login
try {
  final user = await FrappeMobile.auth.login('username', 'password');
  print('Logged in as: ${user.fullName}');
} catch (e) {
  print('Login failed: $e');
}

// Check if user is logged in
final isLoggedIn = await FrappeMobile.auth.isUserLoggedIn();

// Get current user
final currentUser = await FrappeMobile.auth.getCurrentUser();

// Logout
await FrappeMobile.auth.logout();
```

### 3. API Calls

```dart
// Make API calls
final response = await FrappeMobile.makeApiCall(
  endpoint: '/api/resource/Customer',
  method: 'GET',
  queryParameters: {'limit': 10},
);

// Upload files
final uploadResponse = await FrappeMobile.uploadFile(
  endpoint: '/api/method/upload_file',
  file: File('path/to/file.pdf'),
  onSendProgress: (sent, total) {
    print('Upload progress: ${(sent / total * 100).toStringAsFixed(2)}%');
  },
);

// Download files
final downloadResponse = await FrappeMobile.downloadFile(
  endpoint: '/files/file_name.pdf',
  savePath: '/path/to/save/file.pdf',
  onReceiveProgress: (received, total) {
    print('Download progress: ${(received / total * 100).toStringAsFixed(2)}%');
  },
);
```

## API Reference

### Core Classes

#### FrappeMobile

The main entry point for the SDK.

```dart
// Initialize the package
await FrappeMobile.initialize(siteUrl: 'https://your-site.com');

// Get site URL
final siteUrl = await FrappeMobile.getSiteUrl();

// Authentication methods
final user = await FrappeMobile.auth.login('username', 'password');
final isLoggedIn = await FrappeMobile.auth.isUserLoggedIn();
final currentUser = await FrappeMobile.auth.getCurrentUser();
await FrappeMobile.auth.logout();

// Storage methods
await FrappeMobile.storage.cacheData('key', data, Duration(hours: 1));
final cachedData = await FrappeMobile.storage.getCachedData('key');
await FrappeMobile.storage.storeString('key', 'value');
final value = await FrappeMobile.storage.getString('key');
```

#### Authentication

Organized access to authentication methods.

```dart
// Login
final user = await FrappeMobile.auth.login('username', 'password');

// Logout
await FrappeMobile.auth.logout();

// Check login status
final isLoggedIn = await FrappeMobile.auth.isUserLoggedIn();

// Get current user
final user = await FrappeMobile.auth.getCurrentUser();

// Refresh user data
final refreshedUser = await FrappeMobile.auth.refreshUser();
```

#### API

Organized access to API methods.

```dart
// Make API call
final response = await API.call(
  endpoint: '/api/resource/DocType',
  method: 'GET',
  includeAuth: true,
);

// Upload file
final response = await API.upload(
  endpoint: '/api/method/upload_file',
  file: File('path/to/file'),
);

// Download file
final response = await API.download(
  endpoint: '/files/file.pdf',
  savePath: '/path/to/save/file.pdf',
);
```

#### Configuration

Access to package configuration.

```dart
// Get version
final version = Configuration.getVersion();

// Check initialization
final isInitialized = await Configuration.isInitialized();

// Get current config
final config = await Configuration.getCurrent();

// Clear data
await Configuration.clearAllData();
```

### Models

#### FrappeUser

```dart
class FrappeUser {
  final String name;
  final String email;
  final String fullName;
  final String apiKey;
  final String apiSecret;
  final String userId;
  final String username;
  final String firstName;
  final String lastName;
  final String timeZone;
  final String userType;
  final String lastIp;
  final List<FrappeUserRole> roles;
  final List<String> roleProfiles;
  final DateTime? lastLogin;
  final String owner;
  final String creation;
  final String modified;
  final String modifiedBy;
  final int docstatus;
  
  // Helper method to get role names as strings
  List<String> get roleNames;
  
  // Methods
  Map<String, dynamic> toJson();
  factory FrappeUser.fromJson(Map<String, dynamic> json);
  FrappeUser copyWith({...});
}
```

#### FrappeUserRole

```dart
class FrappeUserRole {
  final String name;
  final String role;
  final String parent;
  final String parentfield;
  final String parenttype;
  final String doctype;
  final int idx;
  final int docstatus;
  final String owner;
  final String creation;
  final String modified;
  final String modifiedBy;
  
  // Methods
  Map<String, dynamic> toJson();
  factory FrappeUserRole.fromJson(Map<String, dynamic> json);
}
```

### Services

#### AuthenticationService

Advanced authentication operations.

```dart
final authService = AuthenticationService();

// Login
final user = await authService.login('username', 'password');

// Logout
await authService.logout();

// Check login status
final isLoggedIn = await authService.isUserLoggedIn();

// Get current user
final user = await authService.getCurrentUser();

// Refresh user
final refreshedUser = await authService.refreshUser();
```

#### Storage

Organized access to storage methods including caching.

```dart
// Cache data with expiration
await FrappeMobile.storage.cacheData(
  'user_preferences', 
  {'theme': 'dark', 'language': 'en'}, 
  Duration(hours: 24)
);

// Get cached data
final cachedData = await FrappeMobile.storage.getCachedData('user_preferences');

// Remove cached data
await FrappeMobile.storage.removeCachedData('user_preferences');

// Clear all cache
await FrappeMobile.storage.clearAllCache();

// Store and retrieve basic data types
await FrappeMobile.storage.storeString('key', 'value');
final stringValue = await FrappeMobile.storage.getString('key');

await FrappeMobile.storage.storeBool('isDarkMode', true);
final boolValue = await FrappeMobile.storage.getBool('isDarkMode');

await FrappeMobile.storage.storeInt('count', 42);
final intValue = await FrappeMobile.storage.getInt('count');

await FrappeMobile.storage.storeJson('user_data', {'name': 'John', 'age': 30});
final jsonData = await FrappeMobile.storage.getJson('user_data');

// Secure storage for sensitive data
await FrappeMobile.storage.storeSecureString('api_key', 'secret_key');
final secureValue = await FrappeMobile.storage.getSecureString('api_key');

// Utility methods
await FrappeMobile.storage.removeData('key');
await FrappeMobile.storage.clearAllData();
final storageInfo = await FrappeMobile.storage.getStorageInfo();
```

#### StorageService

Secure local storage operations.

```dart
final storage = StorageService();

// Store user data
await storage.storeUser(user);

// Get user data
final user = await storage.getUser();

// Store site URL
await storage.storeSiteUrl('https://your-site.com');

// Get site URL
final siteUrl = await storage.getSiteUrl();

// Clear all data
await storage.clearAllData();
```

#### ApiClient

Advanced API operations.

```dart
final apiClient = ApiClient();

// Initialize API client
await apiClient.initialize();

// Make API call
final response = await apiClient.request(
  endpoint: '/api/resource/DocType',
  method: 'GET',
);

// Upload file (using FormData)
final formData = FormData();
formData.files.add(
  MapEntry('file', await MultipartFile.fromFile('path/to/file')),
);
final response = await apiClient.request(
  endpoint: '/api/method/upload_file',
  method: 'POST',
  data: formData,
);

// Download file
final response = await apiClient.request(
  endpoint: '/files/file.pdf',
  method: 'GET',
  options: Options(responseType: ResponseType.bytes),
);
```

## Error Handling

The package uses custom exceptions for better error handling:

```dart
try {
  final user = await FrappeMobile.login('username', 'password');
} on FrappeException catch (e) {
  switch (e.type) {
    case FrappeExceptionType.authentication:
      print('Authentication error: ${e.message}');
      break;
    case FrappeExceptionType.network:
      print('Network error: ${e.message}');
      break;
    case FrappeExceptionType.validation:
      print('Validation error: ${e.message}');
      break;
    default:
      print('Unknown error: ${e.message}');
  }
}
```

## Configuration

### Environment Variables

The package supports different environments through constants:

```dart
// Debug mode (set to false in production)
static const bool debugMode = true;

// Timeouts
static const int connectionTimeout = 30;
static const int receiveTimeout = 30;
static const int sendTimeout = 30;

// Retry configuration
static const int maxRetryAttempts = 3;
static const int retryDelaySeconds = 2;
```

### API Endpoints

Common API endpoints are predefined:

```dart
// Authentication
ApiEndpoints.login
ApiEndpoints.logout
ApiEndpoints.userInfo

// Forms
ApiEndpoints.getForm
ApiEndpoints.saveForm
ApiEndpoints.updateForm
ApiEndpoints.deleteForm

// Files
ApiEndpoints.uploadFile
ApiEndpoints.downloadFile
```

## Best Practices

1. **Always initialize the package** before using any functionality
2. **Handle errors properly** using try-catch blocks
3. **Use secure storage** for sensitive data (handled automatically)
4. **Implement proper session management** with automatic logout on errors
5. **Use progress callbacks** for file uploads/downloads
6. **Cache data appropriately** to reduce API calls

## Example Usage

Here's a complete example of how to use the package:

```dart
import 'package:frappe_mobile/frappe_mobile.dart';

class FrappeService {
  static Future<void> initialize() async {
    await FrappeMobile.initialize(siteUrl: 'https://your-frappe-site.com');
  }

  static Future<FrappeUser?> loginUser(String username, String password) async {
    try {
      final user = await FrappeMobile.login(username, password);
      print('Successfully logged in as: ${user.fullName}');
      return user;
    } on FrappeException catch (e) {
      print('Login failed: ${e.message}');
      return null;
    }
  }

  static Future<List<dynamic>> getCustomers() async {
    try {
      final response = await FrappeMobile.makeApiCall(
        endpoint: '/api/resource/Customer',
        method: 'GET',
        queryParameters: {'limit': 20},
      );
      return response.data['data'] ?? [];
    } catch (e) {
      print('Failed to get customers: $e');
      return [];
    }
  }

  static Future<bool> uploadDocument(File file) async {
    try {
      await FrappeMobile.uploadFile(
        endpoint: '/api/method/upload_file',
        file: file,
        onSendProgress: (sent, total) {
          print('Upload progress: ${(sent / total * 100).toStringAsFixed(2)}%');
        },
      );
      return true;
    } catch (e) {
      print('Upload failed: $e');
      return false;
    }
  }
}
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This package is licensed under the MIT License. See the LICENSE file for details.

## Support

For support and questions, please open an issue on the GitHub repository.