import 'package:estudo/globals.dart';
import 'package:estudo/screens/home/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import '../../components/progress/progress_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<HomeCubit>(context);
    return BlocConsumer<HomeCubit, HomeState>(
      listenWhen: (previous, current) => current is FatalErrorHomeState,
      listener: (context, state) {
        if (state is FatalErrorHomeState) {
          final String? errorMessage = state.message;
          toastification.show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored,
            title: const Text("Erro"),
            description: Text("$errorMessage"),
            alignment: Alignment.topRight,
            autoCloseDuration: const Duration(seconds: 5),
            icon: const Icon(Icons.close),
            showProgressBar: true,
          );
        }
      },
      builder: (context, state) {
        if (state is LoadingState) {
          return const ProgressView(
            message: "Obtendo dados de filial e empresa",
          );
        }
        if (state is ShowHomeState) {
          return buildHomeView(context, cubit);
        }
        return const Text('Unknown error');
      },
    );
  }

  Scaffold buildHomeView(BuildContext context, HomeCubit cubit) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${filial["nome"]}",
          style: const TextStyle(color: Color(0xFFF2F2F2)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFF2F2F2)),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 90,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF1a6ed1),
                ),
                child: Text('Central Manager'),
              ),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
