import 'package:acerta_ou_tapa/model/info_jogador.dart';

class Usuario {
  int _id;
  String _nome;
  String _senha;
  String _token;
  InfoJogador _infoJogador;

  Usuario(this._nome, this._senha) {
    _infoJogador = InfoJogador(
      nome: this._nome,
      pontuacao: 0,
      qtdTapaDado: 0,
      qtdTapaRecebido: 0,
    );
  }

  get id => this._id;
  set id(int id) {
    this._id = id;
  }

  get senha => this._senha;
  get nome => this._nome;
  get token => this._token;
  set token(String _t) {
    this._token = _t;
  }

  InfoJogador get infoJogador {
    return this._infoJogador;
  }

  set infoJogador(InfoJogador _ij) {
    this._infoJogador = _ij;
  }
}
