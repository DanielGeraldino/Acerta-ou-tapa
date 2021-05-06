import 'package:flutter/material.dart';

class AlertDialogGame extends StatelessWidget {
  final content;

  AlertDialogGame({this.content});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Fim do game'),
      elevation: 25.0,
      content: content,
      actions: [
        FlatButton(
          onPressed: () => Navigator.pushNamed(
            context,
            '/game_final',
          ),
          child: Text('Proximo'),
        ),
      ],
    );
  }
}
