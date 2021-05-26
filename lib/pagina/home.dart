import 'package:acerta_ou_tapa/utilities/api_banco.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  var widthButton;
  @override
  Widget build(BuildContext context) {
    widthButton = MediaQuery.of(context).size.width * .6;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/logo.png',
                height: 300,
              ),
              ButtonHome(
                titulo: 'CRIAR PARTIDA',
                width: widthButton,
                onPress: () => {
                  Navigator.pushNamed(context, '/catalago'),
                },
              ),
              ButtonHome(
                titulo: 'ACESSAR PARTIDA',
                width: widthButton,
                onPress: () {
                  Navigator.pushNamed(context, '/acessa_partida');
                },
              ),
              ButtonHome(
                titulo: 'HISTORICO',
                width: widthButton,
                onPress: () {},
              ),
              ButtonHome(
                titulo: 'SOBRE',
                width: widthButton,
                onPress: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonHome extends StatelessWidget {
  final titulo;
  final onPress;
  final width;
  final heith;

  ButtonHome({
    this.titulo,
    this.onPress,
    this.width,
    this.heith,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: width,
      // height: heith,
      child: ElevatedButton(
        onPressed: () => onPress(),
        child: Text("$titulo"),
      ),
    );
  }
}
