import 'package:estudo/globals.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../http/clientAPI.dart';

@immutable
abstract class HomeState {
  const HomeState();
}

@immutable
class ShowHomeState extends HomeState {
  const ShowHomeState();
}

@immutable
class LoadingState extends HomeState {
  const LoadingState();
}

@immutable
class FatalErrorHomeState extends HomeState {
  final String? message;

  const FatalErrorHomeState(this.message);
}

class HomeCubit extends Cubit<HomeState> {
  final ClientAPI webClient = ClientAPI();

  HomeCubit() : super(const ShowHomeState());

  void getDadosAPI() async {
    emit(const LoadingState());
    try {
      // Realize a chamada à API
      var resposta = await webClient.getFilial();
      print("A resposta da requisição é ${resposta}");
      filial = resposta;

      var resposta2 = await webClient.getEmpresa();
      print("A resposta da requisição2 é $resposta");
      empresa = resposta2;
      emit(const ShowHomeState());
    } catch (e) {
      emit(FatalErrorHomeState(e.toString()));
    }
  }
}
