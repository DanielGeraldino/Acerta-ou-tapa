import 'package:flutter/material.dart';

class GameFinalizaWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Acerta ou tapa na cara'),
        ),
        body: Text('Tela final do game'),
      ),
    );
  }
}
