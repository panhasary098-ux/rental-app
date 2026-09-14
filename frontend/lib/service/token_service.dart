import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  final FlutterSecureStorage storage =
      FlutterSecureStorage();

  // Save Token
  Future<void> saveToken(String token) async {
    await storage.write(
      key: "auth_token",
      value: token,
    );
  }

  // Get Token
  Future<String?> getToken() async {
    return await storage.read(
      key: "auth_token",
    );
  }

  // Has Token
  Future<bool> hasToken() async {
    String? token = await getToken();

    return token != null && token.isNotEmpty;
  }

  // Delete Token
  Future<void> deleteToken() async {
    await storage.delete(
      key: "auth_token",
    );
  }
}