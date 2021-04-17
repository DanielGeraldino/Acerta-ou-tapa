import 'package:flutter/material.dart';

class GameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Acerta ou leva tapa'),
        ),
        body: Text('Tela game'),
      ),
    );
  }
}
