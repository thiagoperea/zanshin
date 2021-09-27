import 'package:flutter/material.dart';

class SingleInputDialog extends StatefulWidget {
  final String title;
  final String inputLabel;
  final TextInputType textInputType;
  final String confirmButtonLabel;
  final Function onConfirmClick;

  const SingleInputDialog({
    Key? key,
    required this.title,
    required this.inputLabel,
    this.textInputType = TextInputType.text,
    required this.confirmButtonLabel,
    required this.onConfirmClick,
  }) : super(key: key);

  @override
  State<SingleInputDialog> createState() => _SingleInputDialogState();
}

class _SingleInputDialogState extends State<SingleInputDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.title),
      contentPadding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: TextField(
            controller: _controller,
            keyboardType: widget.textInputType,
            decoration: InputDecoration(
              labelText: widget.inputLabel,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.pop(context, null);
              },
            ),
            ElevatedButton(
              child: Text(widget.confirmButtonLabel),
              onPressed: () => widget.onConfirmClick(_controller.text),
            ),
          ],
        )
      ],
    );
  }
}
