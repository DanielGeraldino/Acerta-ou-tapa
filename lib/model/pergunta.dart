import 'package:acerta_ou_tapa/model/resposta.dart';
import 'package:flutter/cupertino.dart';

class Pergunta {
  final enuciado;
  final idEnuciado;
  final idCategoria;
  final idOpacaoCorreta;
  int idPeguntaSelecionada;
  List<Resposta> respostas;

  Pergunta({
    @required this.enuciado,
    @required this.idEnuciado,
    @required this.idCategoria,
    @required this.idOpacaoCorreta,
    @required this.respostas,
  });
}
