class BackendAuthResult {
  final String accessToken;
  final DateTime expiresAt;

  const BackendAuthResult({required this.accessToken, required this.expiresAt});
}
