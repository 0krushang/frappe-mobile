# Frappe Mobile

A Flutter package for integrating with Frappe Framework APIs. This package provides authentication, API calls, file upload/download, and user management functionality for Flutter applications that need to interact with Frappe-based systems.

## Features

- **Authentication**: Login, logout, and user session management
- **API Integration**: Make HTTP requests to Frappe APIs with automatic authentication
- **File Operations**: Upload and download files with progress tracking
- **User Management**: Get current user information and refresh user data
- **Secure Storage**: Secure storage for authentication tokens and site URLs

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  frappe_mobile: ^1.0.0
```

## Usage

### Initialization

```dart
import 'package:frappe_mobile/frappe_mobile.dart';

// Initialize the package with your Frappe site URL
await FrappeMobile.initialize(siteUrl: 'https://your-frappe-site.com');
```

### Authentication

```dart
// Login
FrappeUser user = await FrappeMobile.login('username', 'password');

// Check if user is logged in
bool isLoggedIn = await FrappeMobile.isUserLoggedIn();

// Get current user
FrappeUser? currentUser = await FrappeMobile.getUser();

// Logout
await FrappeMobile.logout();
```

### API Calls

```dart
// Make API calls
Response response = await FrappeMobile.makeApiCall(
  endpoint: '/api/resource/User',
  method: 'GET',
  queryParameters: {'fields': '["name", "email"]'},
);

// POST request with data
Response response = await FrappeMobile.makeApiCall(
  endpoint: '/api/resource/User',
  method: 'POST',
  data: {'name': 'John Doe', 'email': 'john@example.com'},
);
```

### File Operations

```dart
// Upload file
Response uploadResponse = await FrappeMobile.uploadFile(
  endpoint: '/api/method/upload_file',
  file: File('path/to/file.pdf'),
  fileFieldName: 'file',
  additionalData: {'doctype': 'User'},
  onSendProgress: (sent, total) {
    print('Upload progress: ${(sent / total * 100).toStringAsFixed(2)}%');
  },
);

// Download file
Response downloadResponse = await FrappeMobile.downloadFile(
  endpoint: '/api/method/frappe.client.get_file',
  savePath: '/path/to/save/file.pdf',
  onReceiveProgress: (received, total) {
    print('Download progress: ${(received / total * 100).toStringAsFixed(2)}%');
  },
);
```

## API Reference

### FrappeMobile Class

- `initialize({String? siteUrl})` - Initialize the package
- `setUrl(String siteUrl)` - Set the Frappe site URL
- `getSiteUrl()` - Get the current site URL
- `login(String username, String password)` - Authenticate user
- `logout()` - Logout current user
- `isUserLoggedIn()` - Check if user is logged in
- `getUser()` - Get current user information
- `refreshUser()` - Refresh user data
- `makeApiCall()` - Make HTTP requests
- `uploadFile()` - Upload files
- `downloadFile()` - Download files

### Authentication Class

For convenience, you can also use the `Authentication` class:

```dart
// These methods are equivalent to FrappeMobile methods
await Authentication.login('username', 'password');
await Authentication.logout();
bool isLoggedIn = await Authentication.isUserLoggedIn();
FrappeUser? user = await Authentication.getUser();
```

## Dependencies

This package depends on:
- `dio` - For HTTP requests
- `shared_preferences` - For local storage
- `flutter_secure_storage` - For secure storage

## License

This project is licensed under the MIT License.