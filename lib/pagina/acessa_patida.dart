import 'package:acerta_ou_tapa/utilities/api_banco.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class AcessaPatida extends StatefulWidget {
  @override
  _AcessaPatidaState createState() => _AcessaPatidaState();
}

class _AcessaPatidaState extends State<AcessaPatida> {
  final controleText = TextEditingController();
  bool stopBuscarPartida = false;

  List<Map<String, Object>> partidas = [];

  @override
  void initState() {
    super.initState();
    buscarPartida();
  }

  buscarPartida() async {
    Future.doWhile(() async {
      var aux = await ApiBanco.getPartidasOnlie() as List<Map<String, Object>>;
      setState(() {
        partidas = List.from(aux.reversed);
      });

      return !stopBuscarPartida;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerta ou Leva Tapa'),
      ),
      body: ListView(
        children: [
          for (var partida in partidas)
            GestureDetector(
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 3,
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(partida['nome']),
                      Text('Sala ${partida['id']}')
                    ],
                  ),
                  subtitle: Text(
                      'Numero de jogadores: ${partida['quantidadeParticipantes']}'),
                ),
              ),
              onTap: () async {
                EasyLoading.show(status: 'Entrando na partida');
                await ApiBanco.adicionarJogadorPartida(partida['id'])
                    .then((partida) {
                  if (partida != null) {
                    stopBuscarPartida = true;
                    Navigator.pushNamed(context, '/game', arguments: partida);
                    EasyLoading.showSuccess('Sucesso');
                  } else {
                    EasyLoading.showError('Falha ao carregar');
                  }
                }).catchError((onError) {
                  EasyLoading.showError('Falha ao entrar na partida');
                });
              },
            )
        ],
      ),
    );
  }
}
