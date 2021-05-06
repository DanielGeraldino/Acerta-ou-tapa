import 'package:acerta_ou_tapa/model/pergunta.dart';
import 'package:acerta_ou_tapa/model/resposta.dart';
import 'package:acerta_ou_tapa/utilities/alertDialogGame.dart';
import 'package:acerta_ou_tapa/utilities/api_banco.dart';
import 'package:acerta_ou_tapa/utilities/radio_resposta.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class GameWidget extends StatefulWidget {
  @override
  _GameWidgetState createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  var _perguntas = [];
  Pergunta _perguntaAtual = null;
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

  @override
  Widget build(BuildContext context) {
    var _idCategoria = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerta ou leva tapa'),
        automaticallyImplyLeading: false,
      ),
      body: _perguntaAtual != null
          ? Column(
              children: [
                Text(
                  _perguntaAtual.enuciado,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0)),
                for (int i = 0; i < _perguntaAtual.respostas.length; i++)
                  Row(
                    children: [
                      Expanded(
                        child: RadioResposta(
                          value: _perguntaAtual.respostas[i].idOpacao,
                          groupValue: opcaoSelecionado,
                          title:
                              '${_perguntaAtual.respostas[i].idOpacao} - ${_perguntaAtual.respostas[i].descricao}',
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
                  margin:
                      EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 20),
                  child: ElevatedButton(
                    child: Text('PROXIMO'),
                    onPressed: () {
                      if (_perguntaAtual.idPeguntaSelecionada ==
                          _perguntaAtual.idOpacaoCorreta) _qtdAcertos++;
                      if (_perguntas.length == 5) {
                        showDialog(
                            context: context,
                            builder: (BuildContext builder) {
                              return AlertDialogGame(
                                content: Text(
                                    'Você acertou ${(_qtdAcertos / 5) * 100}% das perguntas!'),
                              );
                            });
                      } else {
                        proximaPegunta(_idCategoria);
                      }
                    },
                  ),
                ),
              ],
            )
          : Center(
              child: Container(
                margin:
                    EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 20),
                child: ElevatedButton(
                  child: Text('INICIAR'),
                  onPressed: () {
                    if (_perguntas.length == 5) {
                      Navigator.pushNamed(context, '/game_final');
                    } else {
                      proximaPegunta(_idCategoria);
                    }
                  },
                ),
              ),
            ),
    );
  }
}
