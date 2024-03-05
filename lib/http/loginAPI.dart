import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import '../../services/auth_service.dart';
import '../globals.dart';

class WebClient {
  final AuthService _authService = AuthService();

  Future<void> autentica(String login, String password) async {
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$login:$password'))}';
    final response = await post(
      Uri.parse("${BASE_URL}usuarios/autentica"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': basicAuth
      },
    );

    if (response.statusCode == 200) {
      // Se o servidor retornar uma resposta "OK", parse o JSON
      var data = json.decode(response.body);
      print('Login bem-sucedido: ${data}');
      _authService.storeToken(data['token'], data['refreshToken']);
    } else {
      // Se o servidor não retornar uma resposta "OK", lance um erro
      throw Exception(
          'Falha ao realizar login. Código de Status: ${response.statusCode}');
    }
  }

  Future<bool> renovaToken(token, refreshToken, payload) async {
    final response = await post(Uri.parse("${BASE_URL}usuarios/atualiza_token"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(
            {'refreshToken': refreshToken, 'id_filial': payload["id_filial"]}));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print('Token renovado: $data');
      _authService.storeToken(data['token'], data['refreshToken']);
      return true;
    } else {
      // Se o servidor não retornar uma resposta "OK", lance um erro
      //throw Exception('Falha ao realizar login. Código de Status: ${response.statusCode}');
      return false;
    }
  }

  // Future<void> delete(String _extension) async {
  //   try {
  //     await client.delete(
  //       Uri.parse("$BASE_URL$_extension"),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //     );
  //   } on SocketException {
  //     print('No Internet connection 😑');
  //   } on HttpException {
  //     print("Couldn't find the post 😱");
  //   } on FormatException {
  //     print('Bad response format 👎');
  //   }
  // }
}
