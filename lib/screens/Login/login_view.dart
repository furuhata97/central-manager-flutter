import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../../components/error_view.dart';
import '../../components/progress/progress_view.dart';
import '../../globals.dart' as globals;

import '../auth_check/auth_check.dart';
import '../home/home_view.dart';
import 'login_cubit.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LoginCubit>(context);
    return BlocConsumer<LoginCubit, LoginState>(
      listenWhen: (previous, current) =>
          current is FatalErrorLoginState || current is NavigateToHomeState,
      listener: (context, state) {
        if (state is FatalErrorLoginState) {
          toastification.show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored,
            title: const Text("Erro"),
            description: const Text("Ocorreu um erro ao realizar o login"),
            alignment: Alignment.topRight,
            autoCloseDuration: const Duration(seconds: 5),
            icon: const Icon(Icons.close),
            showProgressBar: true,
          );
        }
        if (state is NavigateToHomeState) {
          goToHomePage(context);
        }
      },
      builder: (context, state) {
        if (state is ShowLoginState) {
          return buildLoginForm(context, cubit);
        }
        if (state is AuthenticationState) {
          return const ProgressView(
            message: "Carregando",
          );
        }
        return const ErrorView('Unknown error');
      },
    );
  }

  void goToHomePage(BuildContext blocContext) async {
    await Navigator.of(blocContext).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Home(),
      ),
    );
  }

  Scaffold buildLoginForm(BuildContext context, LoginCubit cubit) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   title: const Text(
      //     "Central Manager",
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   backgroundColor: Colors.blueAccent,
      // ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            height: 400,
            width: 450,
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Card(
                //color: const Color(0xFFF2F2F2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(width: 1, color: Color(0xFF1a6ed1))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Image.asset("resource/solumobi.png"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: Text(
                        "Central Manager",
                        style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 24)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextField(
                        controller: _loginController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blueGrey, width: 0.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFF1a6ed1), width: 2.0),
                          ),
                          labelText: "Login*",
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blueGrey, width: 0.0),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFF1a6ed1), width: 2.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          labelText: "Senha*",
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1a6ed1),
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () async {
                          if (_loginController.text.isEmpty) {
                            toastification.show(
                              context: context,
                              type: ToastificationType.error,
                              style: ToastificationStyle.fillColored,
                              title: const Text("Login vazio"),
                              description: const Text(
                                  "O campo de login está vazio, preencha este campo para prosseguir"),
                              alignment: Alignment.topRight,
                              autoCloseDuration: const Duration(seconds: 5),
                              icon: const Icon(Icons.close),
                              showProgressBar: true,
                            );
                            return;
                          }
                          if (_passwordController.text.isEmpty) {
                            toastification.show(
                              context: context,
                              type: ToastificationType.error,
                              style: ToastificationStyle.fillColored,
                              title: const Text("Senha vazia"),
                              description: const Text(
                                  "O campo de senha está vazio, preencha este campo para prosseguir"),
                              alignment: Alignment.topRight,
                              autoCloseDuration: const Duration(seconds: 5),
                              icon: const Icon(Icons.close),
                              showProgressBar: true,
                            );
                            return;
                          }
                          cubit.authenticateState(
                              _loginController.text, _passwordController.text);
                        },
                        child: const Text(
                          'ENTRAR',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
