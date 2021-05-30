import 'dart:convert';
import 'dart:typed_data';

import 'package:acerta_ou_tapa/model/partida.dart';
import 'package:acerta_ou_tapa/model/pergunta.dart';
import 'package:acerta_ou_tapa/pagina/card_game.dart';
import 'package:acerta_ou_tapa/utilities/AlertDialogBluetooth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';

import '../utilities/api_banco.dart';

class CatalagoGameWidget extends StatefulWidget {
  @override
  _CatalagoGameWidgetState createState() => _CatalagoGameWidgetState();
}

class _CatalagoGameWidgetState extends State<CatalagoGameWidget> {
  //Lista de categorias de perguntas
  List categorias = [];

  void atualizaCategorias() async {
    var auxCat = await ApiBanco.getCategorias();
    setState(() {
      categorias = auxCat;
    });
  }

  @override
  void initState() {
    super.initState();
    //Busca categorias na api
    atualizaCategorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerta ou Leva Tapa'),
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
                () async {
                  Partida partida =
                      await ApiBanco.iniciarPartida(i['idCategoria']);
                  partida.idCategoriaPerguntas = i['idCategoria'];
                  if (partida != null) {
                    Navigator.pushNamed(
                      context,
                      '/game',
                      arguments: partida,
                    );
                  }
                },
              ),
        ],
      ),
    );
  }
}
