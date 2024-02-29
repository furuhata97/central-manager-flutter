import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


abstract class BlocContainer extends StatelessWidget {
  const BlocContainer({Key? key}) : super(key: key);
}

void push(BuildContext blocContext, BlocContainer container) {
  Navigator.of(blocContext).push(
    MaterialPageRoute(
      builder: (context) => container,
    ),
  );
}

// void pushWithCubit(BuildContext blocContext, BlocContainer container) {
//   Navigator.of(blocContext).push(
//     MaterialPageRoute(
//       builder: (context) => BlocProvider.value(
//         value: BlocProvider.of<CurrentLocaleCubit>(blocContext),
//         child: container,
//       ),
//     ),
//   );
// }