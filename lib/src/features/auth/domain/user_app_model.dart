class UserApp {
  final int id;
  final String fullName;
  final String email;
  final String role;
  final String status;
  final String defaultCurrency;
  final String currentBalance;
  final String? avatarAssetId;
  final String? points;
  final String? provider;
  final String? providerId;

  const UserApp({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.status,
    required this.defaultCurrency,
    required this.currentBalance,
    this.avatarAssetId,
    this.points,
    this.provider,
    this.providerId,
  });

  factory UserApp.fromMap(Map<String, dynamic> map) {
    return UserApp(
      id: map['id'] is int ? map['id'] : int.parse(map['id'].toString()),
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
      status: map['status'] as String,
      defaultCurrency: map['defaultCurrency'] as String,
      currentBalance: map['currentBalance'] as String,
      avatarAssetId: map['avatarAssetId'] as String?,
      points: map['points'] as String?,
      provider: map['provider'] as String?,
      providerId: map['providerId'] as String?,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'role': role,
      'status': status,
      'defaultCurrency': defaultCurrency,
      'currentBalance': currentBalance,
      'avatarAssetId': avatarAssetId,
      'points': points,
      'provider': provider,
      'providerId': providerId,
    };
  }
}

class UserAppMapper {
  static UserApp fromMap(Map<String, dynamic> map) {
    return UserApp.fromMap(map);
  }
}
