import 'package:acerta_ou_tapa/model/pergunta.dart';
import 'package:acerta_ou_tapa/pagina/card_game.dart';
import 'package:flutter/material.dart';

import '../utilities/api_banco.dart';

class CatalagoGameWidget extends StatefulWidget {
  @override
  _CatalagoGameWidgetState createState() => _CatalagoGameWidgetState();
}

class _CatalagoGameWidgetState extends State<CatalagoGameWidget> {
  // pega argumento da tela de login
  List categorias = [];

  void atualizaCategorias(ApiBanco banco) async {
    var aux = await banco.getCategorias();
    setState(() {
      categorias = aux;
    });
  }

  @override
  Widget build(BuildContext context) {
    var banco = ModalRoute.of(context).settings.arguments as ApiBanco;
    atualizaCategorias(banco);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Acerta ou leva tapa'),
          actions: [
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  banco.logout();
                  Navigator.pop(context, true);
                })
          ],
        ),
        body: ListView(
          children: [
            categorias.forEach(
              (element) {
                CardGameWidget(
                  element["nome"],
                  element["descricao"],
                  () {
                    Navigator.pushNamed(context, '/game');
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
