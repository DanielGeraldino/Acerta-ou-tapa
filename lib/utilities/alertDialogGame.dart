import 'package:flutter/material.dart';

class AlertDialogGame extends StatelessWidget {
  final content;
  final void Function() onPressed;

  AlertDialogGame({this.content, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: content,
      elevation: 25.0,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'images/loading.gif',
            height: 100,
          ),
          Text(
            'Aguardando adversario responder',
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          ),
        ],
      ),
      actions: [
        FlatButton(
          onPressed: () => onPressed(),
          child: Text('OK!'),
        ),
      ],
    );
  }
}
