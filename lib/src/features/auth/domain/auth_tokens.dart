class AuthTokens {
  final String token;

  final String? refreshToken;

  const AuthTokens({
    required this.token,
    this.refreshToken,
  });

  factory AuthTokens.fromMap(Map<String, dynamic> map) {
    return AuthTokens(
      token: map['token'] as String,
      refreshToken: map['refresh_token'] as String?,
    );
  }
}

class AuthTokensMapper {
  static AuthTokens fromMap(Map<String, dynamic> map) {
    return AuthTokens.fromMap(map);
  }
}
