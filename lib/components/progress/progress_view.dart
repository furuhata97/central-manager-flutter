import 'package:estudo/components/progress/progress.dart';
import 'package:flutter/material.dart';

class ProgressView extends StatelessWidget {
  final String message;

  const ProgressView({super.key, this.message = "Sending..."});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Progress(
        message: message,
      ),
    );
  }
}
