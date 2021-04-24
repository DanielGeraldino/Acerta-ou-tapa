import 'package:acerta_ou_tapa/pagina/catalago_game.dart';
import 'package:acerta_ou_tapa/pagina/final_game.dart';
import 'package:acerta_ou_tapa/pagina/game.dart';
import 'package:acerta_ou_tapa/pagina/login.dart';
import 'package:flutter/material.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext context) => LoginWidget(),
        '/catalago': (BuildContext context) => CatalagoGameWidget(),
        '/game': (BuildContext context) => GameWidget(),
        '/game_final': (BuildContext context) => GameFinalizaWidget(),
      },
    );
  }
}
