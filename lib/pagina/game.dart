import 'package:acerta_ou_tapa/model/partida.dart';
import 'package:acerta_ou_tapa/model/pergunta.dart';
import 'package:acerta_ou_tapa/model/resposta.dart';
import 'package:acerta_ou_tapa/utilities/alertDialogGame.dart';
import 'package:acerta_ou_tapa/utilities/api_banco.dart';
import 'package:acerta_ou_tapa/utilities/radio_resposta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:toast/toast.dart';

class GameWidget extends StatefulWidget {
  @override
  _GameWidgetState createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  Partida partida;
  List<Pergunta> _perguntas = [];
  Pergunta _perguntaAtual;
  var _qtdAcertos = 0;

  var opcaoSelecionado = 0;

  List<Resposta> _tratarResposta(List respApi) {
    List<Resposta> auxResp = [];
    for (var i = 0; i < respApi.length; i++) {
      auxResp.add(Resposta(
        idOpacao: respApi[i]['idOpcao'],
        descricao: respApi[i]['descricao'],
        idCategoria: respApi[i]['idCategoria'],
      ));
    }
    return auxResp;
  }

  void proximaPegunta(int idCategoria) async {
    var auxPerguta = await ApiBanco.getPergunta(idCategoria);
    List<Resposta> respostas = _tratarResposta(auxPerguta[0]['listaOpcoes']);
    setState(() {
      _perguntaAtual = Pergunta(
        enuciado: auxPerguta[0]['enunciadoPergunta']['descricao'],
        idEnuciado: auxPerguta[0]['enunciadoPergunta']['idEnunciado'],
        idCategoria: auxPerguta[0]['enunciadoPergunta']['idCategoria'],
        idOpacaoCorreta: auxPerguta[0]['enunciadoPergunta']['idOpcaoCorreta'],
        respostas: respostas,
      );
      _perguntas.add(_perguntaAtual);
    });
  }

  void adicinarJogadorPartida(Partida p) async {
    await ApiBanco.adicionarJogadorPartida(p.id).then((partida) {
      if (partida != null) {
        EasyLoading.showSuccess('Iniciando partida');
      } else {
        EasyLoading.showError('Falha iniciar partida');
      }
    }).whenComplete(() => proximaPegunta(p.idCategoriaPerguntas));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.show(status: 'Carregando partida...');
  }

  @override
  Widget build(BuildContext context) {
    partida = ModalRoute.of(context).settings.arguments;
    if (_perguntaAtual == null) adicinarJogadorPartida(partida);
    return Scaffold(
        appBar: AppBar(
          title: Text(
              'Partida atual ${partida.id} - Jogador${ApiBanco.usuario().id}'),
          automaticallyImplyLeading: false,
        ),
        body: _perguntaAtual != null
            ? Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  children: [
                    Text(
                      _perguntaAtual.enuciado,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 0)),
                    for (int i = 0; i < _perguntaAtual.respostas.length; i++)
                      Row(
                        children: [
                          Expanded(
                            child: RadioResposta(
                              value: _perguntaAtual.respostas[i].idOpacao,
                              groupValue: opcaoSelecionado,
                              title: '${_perguntaAtual.respostas[i].descricao}',
                              onChanged: (resp) {
                                setState(() {
                                  opcaoSelecionado = resp;
                                  _perguntaAtual.idPeguntaSelecionada = resp;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 30, right: 30, top: 0, bottom: 20),
                      child: ElevatedButton(
                        child: Text('ENVIAR RESPOSTA'),
                        onPressed: () async {
                          if (_perguntas.length == 5) {
                            showDialog(
                              context: context,
                              builder: (BuildContext builder) {
                                return AlertDialogGame(
                                  content:
                                      Text('Você chegou ao final do game!'),
                                  onPressed: () => Navigator.popUntil(
                                    context,
                                    ModalRoute.withName('/catalago'),
                                  ),
                                );
                              },
                            );
                          } else {
                            var acertou = await ApiBanco.validarRespota(
                                _perguntaAtual.idEnuciado,
                                _perguntaAtual.idPeguntaSelecionada);
                            var textAcertou = acertou
                                ? 'Você acertou esta questão!'
                                : 'Você errou a questão';
                            showDialog(
                              context: context,
                              builder: (BuildContext builder) {
                                return AlertDialogGame(
                                  content: Text(
                                    textAcertou,
                                  ),
                                  onPressed: () {
                                    Navigator.popAndPushNamed(
                                      context,
                                      '/game_final',
                                      arguments: acertou,
                                    );
                                    proximaPegunta(
                                        partida.idCategoriaPerguntas);
                                  },
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Container());
  }
}
