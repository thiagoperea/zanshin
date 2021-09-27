import 'package:flutter/material.dart';

class SimpleLoadingDialog extends StatelessWidget {
  final String loadingText;

  const SimpleLoadingDialog({Key? key, this.loadingText = "Carregando..."}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(loadingText),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
