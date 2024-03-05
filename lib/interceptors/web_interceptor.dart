import 'package:dio/dio.dart';
import 'package:estudo/services/auth_service.dart';

class AuthInterceptor extends Interceptor {
  final AuthService _authService = AuthService();
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    String? token = await _authService.getToken();
    if (token == null) {
      print("********* Não tem token!!");
      throw DioException(
        requestOptions: options,
        response: Response(requestOptions: options),
        type: DioExceptionType.badResponse,
        error: "Unauthorized",
        message: "Usuário está sem token de autenticação",
      );
    }
    if (!(await _authService.isTokenValid(token))) {
      bool tokenRenovado = await _authService.refreshToken();
      if (tokenRenovado) {
        print("O token foi renovado");
        return handler.next(options);
      } else {
        print("O token não foi renovado. Refaça o login");
        await _authService.removeToken();
        throw DioException(
          requestOptions: options,
          response: Response(requestOptions: options),
          type: DioExceptionType.badResponse,
          error: "Unauthorized",
          message: "Não foi possível renovar o token",
        );
      }
    } else {
      print("O token é valido, prosseguir com a requisição");
      return handler.next(options);
    }
  }
}
