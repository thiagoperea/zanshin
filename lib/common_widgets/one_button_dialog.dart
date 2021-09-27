import 'package:flutter/material.dart';

class OneButtonDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final Function? buttonFn;

  const OneButtonDialog({
    Key? key,
    required this.title,
    required this.message,
    this.buttonText = "OK!",
    this.buttonFn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        _createButton(context),
      ],
    );
  }

  Widget _createButton(BuildContext context) {
    return TextButton(
      child: Text(buttonText),
      onPressed: () {
        buttonFn?.call();
        Navigator.of(context).pop();
      },
    );
  }
}
