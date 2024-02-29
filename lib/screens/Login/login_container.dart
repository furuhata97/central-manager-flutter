import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/container.dart';
import 'login_cubit.dart';
import 'login_view.dart';

class LoginContainer extends BlocContainer {
  const LoginContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: LoginView(),
    );
  }
}
