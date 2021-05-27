import 'dart:convert';
import 'dart:html';
import 'package:acerta_ou_tapa/model/partida.dart';
import 'package:acerta_ou_tapa/model/usuario.dart';

import 'package:http/http.dart' as http;

class ApiBanco {
  static Usuario _usuario;
  static bool status = false;
  static final _url =
      Uri.parse('https://perguntasocoapi.azurewebsites.net/api/login');

  static Usuario usuario() => _usuario;

  static criarUsuario(String nome, String senha) {
    var usuario = Usuario(nome, senha);
    ApiBanco._usuario = usuario;
  }

  static logout() {
    status = false;
  }

  static Uri _getUri(String rota) {
    return Uri.parse('https://perguntasocoapi.azurewebsites.net/api/$rota');
  }

  static Future<bool> auth() async {
    var client = http.Client();
    try {
      print('[auntenticação] inicializando...');
      var uriReponse = await client.post(_getUri('login'),
          body: jsonEncode(<String, String>{
            "Username": "${_usuario.nome}",
            "Password": "${_usuario.senha}",
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      print('[auntenticação] http status ${uriReponse.statusCode}');
      if (uriReponse.statusCode == 200) {
        var dado = json.decode(uriReponse.body);
        status = dado['status'];
        print('[auntenticação] usuario autenticado: $status');
        if (status == true) {
          _usuario.token = dado['objectsReturn']['token'];
          _usuario.id = dado['objectsReturn']['idUser'];
          print('[auntenticação] guardando token e id do usuario');
        }
        return status;
      }
      return status;
    } finally {
      print('[auntenticação] finalizada...');
      client.close();
    }
  }

  static Future<List> getCategorias() async {
    var client = http.Client();
    try {
      print('[Buscar categoria] inicializando...');
      print(
          '[Buscar categoria] http get ${_getUri('categoria/?pagina=1&quantidade=5')}...');
      var uriReponse = await client.get(
        _getUri('categoria/?pagina=1&quantidade=5'),
        headers: <String, String>{
          'Authorization': 'Bearer ${_usuario.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('[Buscar categoria] http status ${uriReponse.statusCode}');
      if (uriReponse.statusCode == 200) {
        var dado = json.decode(uriReponse.body);
        print('[Buscar categoria] retornando lista categoria...');
        return dado['objectsReturn'];
      }
      return null;
    } finally {
      print('[Buscar categoria] finalizando get categorias...');
      client.close();
    }
  }

  static Future<List> getPergunta(int idCategoria) async {
    var client = http.Client();
    try {
      print('[Buscar pergunta] inicializando...');
      print(
          '[Buscar pergunta] http get ${_getUri('pergunta?idCategoria=$idCategoria')}');
      var uriReponse = await client.get(
        _getUri('pergunta?idCategoria=$idCategoria'),
        headers: <String, String>{
          'Authorization': 'Bearer ${_usuario.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('[Buscar pergunta] http status ${uriReponse.statusCode}');
      if (uriReponse.statusCode == 200) {
        var dado = json.decode(uriReponse.body);
        return dado['objectsReturn'];
      }
      return null;
    } finally {
      print('[Buscar pergunta] finalizando...');
      client.close();
    }
  }

  static Future<bool> validarRespota(int idEnuciado, int idOpacao) async {
    var client = http.Client();
    try {
      print('[validar resposta] inicilaizado...');
      print('[Validar resposta] http post ${_getUri("pergunta")}...');
      var uriReponse = await client.post(
        _getUri('pergunta'),
        body: jsonEncode({
          "idEnunciado": idEnuciado,
          "idOpcao": idOpacao,
        }),
        headers: <String, String>{
          'Authorization': 'Bearer ${_usuario.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('[validar resposta] http status ${uriReponse.statusCode}');
      if (uriReponse.statusCode == 200) {
        var dado = json.decode(uriReponse.body);
        return dado['objectsReturn'];
      }
      return false;
    } finally {
      print('[validar reposta] finalizando...');
      client.close();
    }
  }

  static Future<Partida> adicionarJogadorPartida(int idPartida) async {
    var client = http.Client();
    try {
      print(
          '[Adicionar jogagador] post: ${_getUri('iniciar-jogo/AdicionarJogador')}...');
      var uriReponse = await client.post(
        _getUri('iniciar-jogo/AdicionarJogador'),
        body: jsonEncode({
          "idUsuario": _usuario.id,
          "idPartida": idPartida,
        }),
        headers: <String, String>{
          // 'Authorization': 'Bearer ${_usuario.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('[Adicionar jogagador] http status ${uriReponse.statusCode}');
      if (uriReponse.statusCode == 200) {
        var dado = json.decode(uriReponse.body);
        Partida partida;
        if (dado['status'] = true) {
          print('[Adicionar jogagador] validado api ${uriReponse.statusCode}');
          var jogador = dado['objectsReturn']['infoJogador'];
          _usuario.infoJogador.pontuacao = jogador['porntuacao'];
          _usuario.infoJogador.qtdTapaDado = jogador['qtdTapaDado'];
          _usuario.infoJogador.qtdTapaRecebido = jogador['qtdTapaRecebido'];

          partida =
              Partida(id: idPartida, ativa: dado['objectsReturn']['ativa']);
        }
        return partida;
      }
      return null;
    } finally {
      print('[Adicionar jogagador] finalizando...');
      client.close();
    }
  }

  static Future<Partida> iniciarPartida() async {
    var client = http.Client();
    try {
      print('[iniciar jogo] post: ${_getUri('iniciar-jogo')}...');
      var uriReponse = await client.post(
        Uri.parse(
            'https://perguntasocoapi.azurewebsites.net/api​/iniciar-jogo'),
      );
      print('[iniciar jogo] http status ${uriReponse.statusCode}');
      if (uriReponse.statusCode == 200) {
        var dado = json.decode(uriReponse.body);
        if (dado['status'] = true) {
          var dadoPartida = dado['objectsReturn'];
          print('[iniciar partida] validado api ${uriReponse.statusCode}');
          var partida = Partida(
              id: dadoPartida['idPartida'], ativa: dadoPartida['ativa']);

          print(
              '[iniciar partida] id ${partida.id} - status partida: ${partida.ativa}');
          return partida;
        }
      }
      return null;
    } finally {
      print('[iniciar partida] finalizando post...');
      client.close();
    }
  }
}
