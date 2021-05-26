import 'package:acerta_ou_tapa/utilities/api_banco.dart';
import 'package:flutter/material.dart';

class AcessaPatida extends StatelessWidget {
  final controleText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerta ou Leva Tapa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .8,
                child: TextFormField(
                  controller: controleText,
                  decoration: InputDecoration(
                    hintText: 'Digite o ID da sala',
                    labelText: 'Digite o ID da sala',
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: MediaQuery.of(context).size.width * .8,
                child: ElevatedButton(
                  child: Text('ENTRAR'),
                  onPressed: () async {
                    var id = controleText.text;
                    if (id.isNotEmpty) {
                      print(id);
                      if (await ApiBanco.adicionarJogadorPartida(
                          int.parse(id))) {
                        Navigator.pushNamed(context, '/game');
                      }
                    } else {
                      print('[acessa partida] id vazio');
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}