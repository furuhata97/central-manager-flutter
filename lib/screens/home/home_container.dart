import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/container.dart';
import 'home_cubit.dart';
import 'home_view.dart';

class HomeContainer extends BlocContainer {
  const HomeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) {
        final cubit = HomeCubit();
        cubit.getDadosAPI();
        return cubit;
      },
      child: const HomeView(),
    );
  }
}
