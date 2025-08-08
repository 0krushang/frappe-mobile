import 'constants.dart';


class FrappeValidators {
  FrappeValidators._();
  static bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }

  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }


  static bool isValidUsername(String? username) {
    if (username == null || username.isEmpty) return false;
    
    // Username should be 3-50 characters, alphanumeric with dots and underscores
    final usernameRegex = RegExp(r'^[a-zA-Z0-9._]{3,50}$');
    return usernameRegex.hasMatch(username);
  }

  static bool isValidPassword(String? password) {
    if (password == null || password.length < FrappeConstants.minPasswordLength) {
      return false;
    }
    
    return true;
  }

  static bool isValidField(String? value, {int? maxLength}) {
    if (value == null || value.trim().isEmpty) return false;
    
    final maxLen = maxLength ?? FrappeConstants.maxFieldLength;
    return value.length <= maxLen;
  }

  static bool isValidFileSize(int fileSizeInBytes) {
    return fileSizeInBytes <= FrappeConstants.maxFileSize;
  }

  static bool isValidFileType(String fileName) {
    if (fileName.isEmpty) return false;
    
    final extension = fileName.split('.').last.toLowerCase();
    return FrappeConstants.supportedFileTypes.contains(extension);
  }

  static bool isValidDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return false;
    
    try {
      DateTime.parse(dateString);
      return true;
    } catch (e) {
      return false;
    }
  }

  static bool isValidDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return false;
    
    try {
      DateTime.parse(dateTimeString);
      return true;
    } catch (e) {
      return false;
    }
  }

  static bool isValidPhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) return false;
    
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    return digitsOnly.length >= 7 && digitsOnly.length <= 15;
  }

  static bool isValidApiKey(String? apiKey) {
    if (apiKey == null || apiKey.isEmpty) return false;
    
    final apiKeyRegex = RegExp(r'^[a-zA-Z0-9]{20,}$');
    return apiKeyRegex.hasMatch(apiKey);
  }

  static bool isValidApiSecret(String? apiSecret) {
    if (apiSecret == null || apiSecret.isEmpty) return false;
    
    final apiSecretRegex = RegExp(r'^[a-zA-Z0-9]{20,}$');
    return apiSecretRegex.hasMatch(apiSecret);
  }


  static bool hasRequiredFields(Map<String, dynamic> data, List<String> requiredFields) {
    for (final field in requiredFields) {
      if (!data.containsKey(field) || data[field] == null) {
        return false;
      }
    }
    return true;
  }


  static bool isNotEmpty(List<dynamic>? list) {
    return list != null && list.isNotEmpty;
  }


  static bool isNotEmptyMap(Map<String, dynamic>? map) {
    return map != null && map.isNotEmpty;
  }


  static String sanitizeUrl(String url) {
    String sanitized = url.trim();
    

    if (sanitized.endsWith('/')) {
      sanitized = sanitized.substring(0, sanitized.length - 1);
    }
    

    if (!sanitized.startsWith('http://') && !sanitized.startsWith('https://')) {
      sanitized = 'https://$sanitized';
    }
    
    return sanitized;
  }


  static String sanitizeEmail(String email) {
    return email.trim().toLowerCase();
  }


  static String sanitizeUsername(String username) {
    return username.trim().toLowerCase();
  }


  static String getValidationErrorMessage(String fieldName, String? value, {String? customMessage}) {
    if (customMessage != null) return customMessage;
    
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    switch (fieldName.toLowerCase()) {
      case 'email':
        return isValidEmail(value) ? '' : 'Please enter a valid email address';
      case 'username':
        return isValidUsername(value) ? '' : 'Username must be 3-50 characters and contain only letters, numbers, dots, and underscores';
      case 'password':
        return isValidPassword(value) ? '' : 'Password must be at least ${FrappeConstants.minPasswordLength} characters';
      case 'url':
      case 'site url':
        return isValidUrl(value) ? '' : 'Please enter a valid URL';
      case 'phone':
      case 'phone number':
        return isValidPhoneNumber(value) ? '' : 'Please enter a valid phone number';
      default:
        return '';
    }
  }
}
