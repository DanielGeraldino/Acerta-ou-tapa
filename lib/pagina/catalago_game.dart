import 'package:acerta_ou_tapa/pagina/card_game.dart';
import 'package:flutter/material.dart';

import '../utilities/api_banco.dart';
import '../utilities/api_banco.dart';

class CatalagoGameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // pega argumento da tela de login
    var banco = ModalRoute.of(context).settings.arguments as ApiBanco;
    print("token ${banco.token}");
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Acerta ou leva tapa'),
        ),
        body: ListView(
          children: [
            CardGameWidget(
              'Jogo 1 - Animes',
              'Perguntas sobre animes variados',
              () {
                Navigator.pushNamed(context, '/game');
              },
            ),
          ],
        ),
      ),
    );
  }
}
