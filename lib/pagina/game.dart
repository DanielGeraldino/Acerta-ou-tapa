import 'dart:async';

import 'package:acerta_ou_tapa/model/partida.dart';
import 'package:acerta_ou_tapa/model/pergunta.dart';
import 'package:acerta_ou_tapa/model/resposta.dart';
import 'package:acerta_ou_tapa/utilities/api_banco.dart';
import 'package:acerta_ou_tapa/utilities/bluetooth.dart';
import 'package:acerta_ou_tapa/utilities/radio_resposta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class GameWidget extends StatefulWidget {
  Partida _partida;

  GameWidget(this._partida);

  @override
  _GameWidgetState createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  // Partida partida = Partida(ativa: true, id: 105, idCategoriaPerguntas: 1);

  Bluetooth controleBlue;

  List<Pergunta> _perguntas = [];
  int qtdPerguntas = 0;
  Pergunta _perguntaAtual;
  var opcaoSelecionado = -1;
  Color corButtonEnviar = Colors.blue;
  String textoButtonEnviar;
  bool partidaAtiva = true;
  bool mostrarResposta = false;
  bool acertou = false;
  bool adversarioAcertou = false;
  bool minhaVez = false;
  int qtdTapaDado = 0;
  int qtdTapaRecebido = 0;
  bool isClickTapa = false;

  Partida partida() => widget._partida;

  void setStatusButtonEnviar() {
    setState(() {
      if (!mostrarResposta) {
        corButtonEnviar = Colors.blue;
        textoButtonEnviar = 'ENVIAR RESPOSTA';
      } else {
        if (acertou) {
          corButtonEnviar = Colors.green;
          textoButtonEnviar = 'PARABENS TROUXA! NÃO VAI RECEBER TAPA!';
        } else {
          corButtonEnviar = Colors.red;
          textoButtonEnviar = 'OOOHHH! VOU TER QUE AMASSAR SUA CARA';
        }
      }
    });
  }

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

  _proximaPegunta(int idPartida, int idCategoriaPerguntas) async {
    var auxPerguta =
        await ApiBanco.getPergunta(idPartida, idCategoriaPerguntas);
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
      mostrarResposta = false;
    });
    setStatusButtonEnviar();
  }

  void _adicinarJogadorPartida(Partida p) async {
    await ApiBanco.adicionarJogadorPartida(p.id).then((partida) {
      if (partida != null) {
        EasyLoading.showSuccess('Iniciando partida');
      } else {
        EasyLoading.showError('Falha iniciar partida');
      }
    }).whenComplete(() => _proximaPegunta(p.id, p.idCategoriaPerguntas));
  }

  Future<void> validandoPergunta() async {
    EasyLoading.show(status: 'Corrigindo');
    await ApiBanco.validarRespota2(
      _perguntaAtual.idEnuciado,
      _perguntaAtual.idPeguntaSelecionada,
      partida().id,
    ).then((value) {
      setState(() {
        acertou = value;
        mostrarResposta = true;
      });
    });
    EasyLoading.showSuccess(
      'Acertou: $acertou',
    );
    qtdPerguntas++;
    setStatusButtonEnviar();
    await Future.delayed(Duration(seconds: 2));
  }

  Future<void> verificarValidacaoAdversario() async {
    EasyLoading.show(status: 'Esperando adversario');
    await ApiBanco.verificarAdversarioAcertou().then(
      (value) {
        EasyLoading.showSuccess("Advesario: ${value.toString()}");
        adversarioAcertou = value;
      },
    );
  }

  Future<void> verificarStatusPartida(int idPartida) {
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 30));
      var ativa = await ApiBanco.verificarPartidaAtiva(idPartida);
      return ativa;
    }).then((value) => partidaAtiva = value);
  }

  void fecharPartida() {
    partidaAtiva = false;
    ApiBanco.finalizarPartida(partida().id);
    Navigator.popUntil(context, ModalRoute.withName('/home'));
  }

  void darTapa() {
    if (controleBlue.isConnected) {
      controleBlue.sendOnMessageToBluetooth();
    }
    qtdTapaDado++;
    print('Deu tapa');
  }

  void levarTapa() {
    qtdTapaRecebido++;
    print('levou tapa');
  }

  @override
  Future<void> initState() {
    super.initState();
    verificarVez();
    EasyLoading.show(status: 'Favor esperar sua vez');
  }

  Future<void> verificarVez() {
    Future.doWhile(() async {
      var auxMinhaVez = await ApiBanco.vericarVez(partida().id);

      setState(() {
        minhaVez = auxMinhaVez;
      });

      await Future.delayed(Duration(seconds: 5));
      return partidaAtiva;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_perguntaAtual == null && minhaVez) {
      _proximaPegunta(partida().id, partida().idCategoriaPerguntas);
      EasyLoading.dismiss();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Partida atual ${partida().id} - Jogador ${ApiBanco.usuario().nome} - N° Pergunta ${qtdPerguntas + 1}'),
        automaticallyImplyLeading: false,
      ),
      body: qtdPerguntas <= 3 && _perguntaAtual != null
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
                        left: 10, right: 10, top: 0, bottom: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: corButtonEnviar),
                      child: Text('$textoButtonEnviar'),
                      onPressed: () async {
                        if (!mostrarResposta) {
                          if (opcaoSelecionado != -1) {
                            if (minhaVez) {
                              await validandoPergunta();
                            } else {
                              EasyLoading.showInfo(
                                  'Liberando sua vez. Tente novamente...');
                            }
                          } else {
                            EasyLoading.showInfo('Selecione um opção');
                          }
                          // await verificarValidacaoAdversario();
                        } else {
                          if (acertou) {
                            darTapa();
                          } else {
                            levarTapa();
                          }
                          isClickTapa = true;
                        }
                      },
                    ),
                  ),
                  if (mostrarResposta)
                    Container(
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 0, bottom: 20),
                      child: ElevatedButton(
                          child: Text('PROXIMA QUESTÃO'),
                          onPressed: () async {
                            if (!isClickTapa) {
                              EasyLoading.showInfo(
                                  'Use o botão de cima para o tapa');
                            } else {
                              if (minhaVez) {
                                _proximaPegunta(partida().id,
                                    partida().idCategoriaPerguntas);
                                isClickTapa = false;
                                opcaoSelecionado = -1;
                              } else {
                                EasyLoading.showInfo(
                                    'Esperando o adversario responder');
                              }
                            }
                          }),
                    ),
                ],
              ),
            )
          : minhaVez || qtdPerguntas == 3
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          'Voce levo $qtdTapaRecebido tapas e deu $qtdTapaDado!'),
                      Container(
                        margin: EdgeInsets.only(
                            left: 30, right: 30, top: 0, bottom: 20),
                        child: ElevatedButton(
                          child: Text('FINALIZAR PARTIDA'),
                          onPressed: () {
                            fecharPartida();
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : Center(),
    );
  }
}
