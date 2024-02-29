import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../http/httpClient.dart';

@immutable
abstract class LoginState {
  const LoginState();
}

@immutable
class ShowLoginState extends LoginState {
  const ShowLoginState();
}

@immutable
class AuthenticationState extends LoginState {
  const AuthenticationState();
}

@immutable
class NavigateToHomeState extends LoginState {
  const NavigateToHomeState();
}

@immutable
class FatalErrorLoginState extends LoginState {
  final String? _message;

  const FatalErrorLoginState(this._message);
}


class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const ShowLoginState());

  void authenticateState(login, password) async {
    emit(const AuthenticationState());
    final WebClient webClient = WebClient();
    try {
      await webClient.autentica(
        login,
        password,
      );
      emit(const NavigateToHomeState());
    } catch (error) {
      emit(const FatalErrorLoginState("Erro ao realizar login"));
      emit(const ShowLoginState());
      print("O erro é $error");
    }
  }
}