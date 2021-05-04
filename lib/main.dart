import 'package:acerta_ou_tapa/pagina/catalago_game.dart';
import 'package:acerta_ou_tapa/pagina/final_game.dart';
import 'package:acerta_ou_tapa/pagina/game.dart';
import 'package:acerta_ou_tapa/pagina/login.dart';
import 'package:acerta_ou_tapa/utilities/api_banco.dart';
import 'package:flutter/material.dart';

main() => runApp(TapaNaCara());

class TapaNaCara extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginWidget(),
        '/catalago': (BuildContext context) => CatalagoGameWidget(),
        '/game': (BuildContext context) => GameWidget(),
        '/game_final': (BuildContext context) => GameFinalizaWidget(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/catalago') {
          print('teste 222');
        }
      },
    );
  }
}
