import 'dart:convert';

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

  const FrappeUserRole({
    required this.name,
    required this.role,
    required this.parent,
    required this.parentfield,
    required this.parenttype,
    required this.doctype,
    required this.idx,
    required this.docstatus,
    required this.owner,
    required this.creation,
    required this.modified,
    required this.modifiedBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
      'parent': parent,
      'parentfield': parentfield,
      'parenttype': parenttype,
      'doctype': doctype,
      'idx': idx,
      'docstatus': docstatus,
      'owner': owner,
      'creation': creation,
      'modified': modified,
      'modified_by': modifiedBy,
    };
  }

  factory FrappeUserRole.fromJson(Map<String, dynamic> json) {
    return FrappeUserRole(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      parent: json['parent'] ?? '',
      parentfield: json['parentfield'] ?? '',
      parenttype: json['parenttype'] ?? '',
      doctype: json['doctype'] ?? '',
      idx: json['idx'] ?? 0,
      docstatus: json['docstatus'] ?? 0,
      owner: json['owner'] ?? '',
      creation: json['creation'] ?? '',
      modified: json['modified'] ?? '',
      modifiedBy: json['modified_by'] ?? '',
    );
  }
}

class FrappeUser {
  final String name;
  final String email;
  final String fullName;
  final String apiKey;
  final String apiSecret;
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

  const FrappeUser({
    required this.name,
    required this.email,
    required this.fullName,
    required this.apiKey,
    required this.apiSecret,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.timeZone,
    required this.userType,
    required this.lastIp,
    this.roles = const [],
    this.roleProfiles = const [],
    this.lastLogin,
    required this.owner,
    required this.creation,
    required this.modified,
    required this.modifiedBy,
    required this.docstatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'full_name': fullName,
      'api_key': apiKey,
      'api_secret': apiSecret,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'time_zone': timeZone,
      'user_type': userType,
      'last_ip': lastIp,
      'roles': roles.map((role) => role.toJson()).toList(),
      'role_profiles': roleProfiles,
      'last_login': lastLogin?.toIso8601String(),
      'owner': owner,
      'creation': creation,
      'modified': modified,
      'modified_by': modifiedBy,
      'docstatus': docstatus,
    };
  }

  factory FrappeUser.fromJson(Map<String, dynamic> json) {
    return FrappeUser(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      apiKey: json['api_key'] ?? '',
      apiSecret: json['api_secret'] ?? '',
      username: json['username'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      timeZone: json['time_zone'] ?? '',
      userType: json['user_type'] ?? '',
      lastIp: json['last_ip'] ?? '',
      roles: (json['roles'] as List<dynamic>?)
          ?.map((role) => FrappeUserRole.fromJson(role))
          .toList() ?? [],
      roleProfiles: List<String>.from(json['role_profiles'] ?? []),
      lastLogin: json['last_login'] != null 
          ? DateTime.parse(json['last_login']) 
          : null,
      owner: json['owner'] ?? '',
      creation: json['creation'] ?? '',
      modified: json['modified'] ?? '',
      modifiedBy: json['modified_by'] ?? '',
      docstatus: json['docstatus'] ?? 0,
    );
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory FrappeUser.fromJsonString(String jsonString) {
    return FrappeUser.fromJson(jsonDecode(jsonString));
  }

  FrappeUser copyWith({
    String? name,
    String? email,
    String? fullName,
    String? apiKey,
    String? apiSecret,
    String? userId,
    String? username,
    String? firstName,
    String? lastName,
    String? timeZone,
    String? userType,
    String? lastIp,
    List<FrappeUserRole>? roles,
    List<String>? roleProfiles,
    DateTime? lastLogin,
    String? owner,
    String? creation,
    String? modified,
    String? modifiedBy,
    int? docstatus,
  }) {
    return FrappeUser(
      name: name ?? this.name,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      apiKey: apiKey ?? this.apiKey,
      apiSecret: apiSecret ?? this.apiSecret,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      timeZone: timeZone ?? this.timeZone,
      userType: userType ?? this.userType,
      lastIp: lastIp ?? this.lastIp,
      roles: roles ?? this.roles,
      roleProfiles: roleProfiles ?? this.roleProfiles,
      lastLogin: lastLogin ?? this.lastLogin,
      owner: owner ?? this.owner,
      creation: creation ?? this.creation,
      modified: modified ?? this.modified,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      docstatus: docstatus ?? this.docstatus,
    );
  }

  // Helper method to get role names as strings
  List<String> get roleNames => roles.map((role) => role.role).toList();

  @override
  String toString() {
    return 'FrappeUser(name: $name, email: $email, fullName: $fullName, username: $username)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FrappeUser &&
        other.name == name &&
        other.email == email; 
  }

  @override
  int get hashCode => name.hashCode ^ email.hashCode;
}