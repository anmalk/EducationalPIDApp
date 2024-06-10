import 'package:flutter/material.dart';

class HelpDialog extends StatelessWidget {
  final String title;
  final String content;

  const HelpDialog({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Закрыть'),
        ),
      ],
    );
  }
}
