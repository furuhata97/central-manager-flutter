import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../http/httpClient.dart';

class AuthService {
  Future<void> storeToken(String token, String refreshToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('app-token', token);
    await prefs.setString('refresh-token', refreshToken);
  }

  Future<void> removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('app-token');
    await prefs.remove('refresh-token');
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('app-token');
    if (token != null) {
      Map<String, dynamic> payload = JwtDecoder.decode(token ?? "");
      print("As informações do token são ${payload}");
    }
    return token;
  }

  Future<bool> isTokenValid(String token) async {
    bool isExpired = JwtDecoder.isExpired(token);
    if (isExpired) {
      print("O token expirou");
      return false;
    }
    print("O token ainda é valido");
    return true;
  }

  Future<bool> refreshToken() async {
    final WebClient webClient = WebClient();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('app-token');
    String? refreshToken = prefs.getString('refresh-token');
    if (token != null && refreshToken != null) {
      Map<String, dynamic> payload = JwtDecoder.decode(token ?? "");
      return webClient.renovaToken(token, refreshToken, payload);
    } else {
      return false;
    }
  }
}
