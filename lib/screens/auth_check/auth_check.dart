import 'package:estudo/screens/Login/login_container.dart';
import 'package:estudo/screens/home/home_view.dart';
import 'package:flutter/material.dart';

import '../../components/progress/progress_view.dart';
import '../../services/auth_service.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final AuthService _authService = AuthService();
  bool carregando = false;
  String tela = "login";

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  void _checkToken() async {
    setState(() {
      carregando = true;
    });
    String? token = await _authService.getToken();
    if (token == null) {
      print("********* Não tem token!!");
      _navigateToLogin();
      return;
    }
    if (!(await _authService.isTokenValid(token))) {
      bool tokenRenovado = await _authService.refreshToken();
      if (tokenRenovado) {
        print("O token foi renovado");
        _navigateToHome();
      } else {
        print("O token não foi renovado. Refaça o login");
        await _authService.removeToken();
        _navigateToLogin();
      }
    } else {
      _navigateToHome();
    }
  }

  void _navigateToLogin() {
    setState(() {
      tela = "login";
      carregando = false;
    });
  }

  void _navigateToHome() {
    setState(() {
      tela = "home";
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const ProgressView(message: 'Verificando login...');
    } else {
      if (tela == "home") {
        return const Home();
      } else {
        return const LoginContainer();
      }
    }
  }
}
