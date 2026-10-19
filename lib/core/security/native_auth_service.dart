abstract interface class NativeAuthService {
  Future<bool> isAvailable();

  Future<bool> authenticate();

  Future<void> stopAuthentication();
}
