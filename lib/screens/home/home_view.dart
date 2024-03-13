import 'package:estudo/components/clientCard/clientCard.dart';
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
          return buildHomeView(context, cubit, state.clientes);
        }
        return const Text('Unknown error');
      },
    );
  }

  Scaffold buildHomeView(
      BuildContext context, HomeCubit cubit, List<dynamic>? clientes) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${filial["nome"]}",
          style: const TextStyle(color: Color(0xFFF2F2F2)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFF2F2F2)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                items: const [
                  DropdownMenuItem<String>(
                    value: "Sair",
                    child: Text("Sair"),
                  )
                ],
                onChanged: (String? value) {
                  if (value is String && value == "Sair") {
                    print("Fazer logout");
                  }
                },
              ),
            ),
          )
        ],
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
      body: Container(
          child: clientes != null
              ? Column(
                  children: [
                    const Text(
                      "Clientes",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: clientes.length,
                          itemBuilder: (context, index) {
                            final item = clientes[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: clientCard(item, context),
                            );
                          }),
                    ),
                  ],
                )
              : const Text("Não foi possível encontrar clientes")),
    );
  }
}
