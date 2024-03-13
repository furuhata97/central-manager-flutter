import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:estudo/screens/Login/login_container.dart';
import 'package:http/http.dart';
import 'package:estudo/interceptors/web_interceptor.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../interceptors/dio_client.dart';
import 'dart:convert';
import '../../services/auth_service.dart';
import '../globals.dart';

class ClientAPI {
  final AuthService _authService = AuthService();

  Future<dynamic> getFilial() async {
    String? token = await _authService.getToken();
    if (token == null) {
      throw Exception('Erro, token não encontrado');
    }
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    print("O token é $decodedToken");
    try {
      final response = await dio.get(
        "filiais/${decodedToken["id_filial"]}",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token'
          }
        ),
      );
      return response.data;
    } on DioException catch (e) {
      if (e.error == "Unauthorized" && e.message == "Não foi possível renovar o token") {
        return const LoginContainer();
      } else {
        throw Exception(
          'Falha ao buscar filial. Código de Status: ${e.response?.statusCode} - ${e.message}');
      }
    }
  }

  Future<dynamic> getEmpresa() async {
    String? token = await _authService.getToken();
    if (token == null) {
      throw Exception('Erro, token não encontrado');
    }
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    try {
      final response = await dio.get(
        "empresas/${decodedToken["id_empresa"]}",
        options: Options(
            headers: {
              'Authorization': 'Bearer $token'
            }
        ),
      );
      return response.data;
    } on DioException catch (e) {
      if (e.error == "Unauthorized" && e.message == "Não foi possível renovar o token") {
        return const LoginContainer();
      } else {
        throw Exception(
            'Falha ao buscar empresa. Código de Status: ${e.response?.statusCode} - ${e.message}');
      }
    }
  }

  Future<dynamic> getClientes() async {
    String? token = await _authService.getToken();
    if (token == null) {
      throw Exception('Erro, token não encontrado');
    }
    //Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    try {
      final response = await dio.get(
        "clientes",
        options: Options(
            headers: {
              'Authorization': 'Bearer $token'
            }
        ),
      );
      return response.data;
    } on DioException catch (e) {
      if (e.error == "Unauthorized" && e.message == "Não foi possível renovar o token") {
        return const LoginContainer();
      } else {
        throw Exception(
            'Falha ao buscar empresa. Código de Status: ${e.response?.statusCode} - ${e.message}');
      }
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
