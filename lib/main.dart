import 'package:acerta_ou_tapa/pagina/catalago_game.dart';
import 'package:acerta_ou_tapa/pagina/final_game.dart';
import 'package:acerta_ou_tapa/pagina/game.dart';
import 'package:acerta_ou_tapa/pagina/login.dart';
import 'package:flutter/material.dart';

main() => runApp(TapaNaCara());

class TapaNaCara extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        accentColor: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginWidget(),
        '/catalago': (BuildContext context) => CatalagoGameWidget(),
        '/game': (BuildContext context) => GameWidget(),
        '/game_final': (BuildContext context) => GameFinalizaWidget(),
      },
    );
  }
}
