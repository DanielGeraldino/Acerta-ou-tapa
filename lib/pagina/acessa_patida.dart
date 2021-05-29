import 'package:acerta_ou_tapa/utilities/api_banco.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
                      EasyLoading.show(status: 'Entrando na partida');
                      await ApiBanco.adicionarJogadorPartida(int.parse(id))
                          .then((partida) {
                        if (partida != null) {
                          Navigator.pushNamed(context, '/game',
                              arguments: partida);
                          EasyLoading.showSuccess('Sucesso');
                        } else {
                          EasyLoading.showError('Falha ao carregar');
                        }
                      }).catchError((onError) {
                        EasyLoading.showError('Falha ao entrar na partida');
                      });
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
