import 'package:acerta_ou_tapa/model/pergunta.dart';
import 'package:acerta_ou_tapa/pagina/card_game.dart';
import 'package:flutter/material.dart';

import '../utilities/api_banco.dart';

class CatalagoGameWidget extends StatefulWidget {
  @override
  _CatalagoGameWidgetState createState() => _CatalagoGameWidgetState();
}

class _CatalagoGameWidgetState extends State<CatalagoGameWidget> {
  List categorias = [];

  void atualizaCategorias() async {
    var auxCat = await ApiBanco.getCategorias();
    setState(() {
      categorias = auxCat;
    });
  }

  @override
  Widget build(BuildContext context) {
    atualizaCategorias();
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerta ou leva tapa'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                ApiBanco.logout();
                Navigator.popUntil(
                  context,
                  ModalRoute.withName('/login'),
                );
              })
        ],
      ),
      body: ListView(
        children: [
          for (var i in categorias)
            if (i['nome'] != null && i['descricao'] != null)
              CardGameWidget(
                i['nome'],
                i['descricao'],
                () => Navigator.pushNamed(
                  context,
                  '/game',
                  arguments: i['idCategoria'] as int,
                ),
              ),
        ],
      ),
    );
  }
}
