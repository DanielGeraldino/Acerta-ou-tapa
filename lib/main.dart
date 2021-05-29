import 'package:acerta_ou_tapa/model/partida.dart';
import 'package:acerta_ou_tapa/pagina/acessa_patida.dart';
import 'package:acerta_ou_tapa/pagina/catalago_game.dart';
import 'package:acerta_ou_tapa/pagina/final_game.dart';
import 'package:acerta_ou_tapa/pagina/game.dart';
import 'package:acerta_ou_tapa/pagina/login.dart';
import 'package:acerta_ou_tapa/pagina/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
      builder: EasyLoading.init(),
      initialRoute: '/login',

      // home: LoginWidget(),
      routes: {
        '/login': (BuildContext context) => LoginWidget(),
        '/home': (BuildContext context) => HomePage(),
        '/acessa_partida': (BuildContext context) => AcessaPatida(),
        '/catalago': (BuildContext context) => CatalagoGameWidget(),
        // '/game': (BuildContext context) => GameWidget(settings.arguments),
        '/game_final': (BuildContext context) => GameFinalizaWidget(),
      },
      onGenerateRoute: (settings) {
        var routes = {
          '/login': (BuildContext context) => LoginWidget(),
          '/home': (BuildContext context) => HomePage(),
          '/acessa_partida': (BuildContext context) => AcessaPatida(),
          '/catalago': (BuildContext context) => CatalagoGameWidget(),
          '/game': (BuildContext context) => GameWidget(settings.arguments),
          '/game_final': (BuildContext context) => GameFinalizaWidget(),
        };

        if (settings.name == '/game') {
          WidgetBuilder builder = routes[settings.name];
          return MaterialPageRoute(builder: (context) => builder(context));
        }
      },
    );
  }
}
