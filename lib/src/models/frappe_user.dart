import 'dart:convert';

class FrappeUser {
  final String name;
  final String email;
  final String fullName;
  final String apiKey;
  final String apiSecret;
  final String userId;
  final List<String> roles;
  final DateTime? lastLogin;

  const FrappeUser({
    required this.name,
    required this.email,
    required this.fullName,
    required this.apiKey,
    required this.apiSecret,
    required this.userId,
    this.roles = const [],
    this.lastLogin,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'full_name': fullName,
      'api_key': apiKey,
      'api_secret': apiSecret,
      'user_id': userId,
      'roles': roles,
      'last_login': lastLogin?.toIso8601String(),
    };
  }

  // Create from JSON
  factory FrappeUser.fromJson(Map<String, dynamic> json) {
    return FrappeUser(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      apiKey: json['api_key'] ?? '',
      apiSecret: json['api_secret'] ?? '',
      userId: json['user_id'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
      lastLogin: json['last_login'] != null 
          ? DateTime.parse(json['last_login']) 
          : null,
    );
  }

  // Convert to JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }

  // Create from JSON string
  factory FrappeUser.fromJsonString(String jsonString) {
    return FrappeUser.fromJson(jsonDecode(jsonString));
  }

  // Copy with method for updates
  FrappeUser copyWith({
    String? name,
    String? email,
    String? fullName,
    String? apiKey,
    String? apiSecret,
    String? userId,
    List<String>? roles,
    DateTime? lastLogin,
  }) {
    return FrappeUser(
      name: name ?? this.name,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      apiKey: apiKey ?? this.apiKey,
      apiSecret: apiSecret ?? this.apiSecret,
      userId: userId ?? this.userId,
      roles: roles ?? this.roles,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  @override
  String toString() {
    return 'FrappeUser(name: $name, email: $email, fullName: $fullName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FrappeUser &&
        other.name == name &&
        other.email == email &&
        other.userId == userId;
  }

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ userId.hashCode;
}