
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String _message;

  const ErrorView(this._message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Processing'),
      ),
      body: Text(_message),
    );
  }
}