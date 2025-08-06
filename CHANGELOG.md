# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial package structure
- Authentication service with login/logout functionality
- API service for making HTTP requests to Frappe APIs
- Storage service for secure token and URL storage
- File upload and download functionality with progress tracking
- User management and session handling
- Comprehensive documentation and examples

### Changed
- Converted from Flutter app to Flutter package structure
- Removed all platform-specific files (android, ios, web, etc.)
- Updated pubspec.yaml for package configuration
- Replaced app-specific tests with package tests

## [1.0.0] - 2024-01-XX

### Added
- Initial release of Frappe Mobile Flutter package
- Core `FrappeMobile` class with static methods for API integration
- `Authentication` class for convenient auth operations
- Support for Frappe Framework API integration
- Secure storage for authentication tokens
- File upload/download with progress callbacks
- URL formatting and validation
- Comprehensive error handling

### Features
- **Authentication**: Login, logout, user session management
- **API Integration**: Make HTTP requests to Frappe APIs with automatic authentication
- **File Operations**: Upload and download files with progress tracking
- **User Management**: Get current user information and refresh user data
- **Secure Storage**: Secure storage for authentication tokens and site URLs

### Dependencies
- `dio: ^5.8.0+1` - For HTTP requests
- `shared_preferences: ^2.5.3` - For local storage
- `flutter_secure_storage: ^9.2.4` - For secure storage
- `cupertino_icons: ^1.0.8` - For iOS style icons

---

## Version History

- **1.0.0** - Initial release with core functionality 