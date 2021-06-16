import 'dart:convert';
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
          print(_usuario.token);
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

  static Future<List> getPergunta(
      int idPartida, int idCategoriaPerguntas) async {
    var client = http.Client();
    try {
      print('[Buscar pergunta] inicializando...');
      print(
          '[Buscar pergunta] http get ${_getUri('pergunta?idCategoria=1&idUsuario=${_usuario.id}&idPartida=$idPartida')}');
      var uriReponse = await client.get(
        _getUri(
            'pergunta?idCategoria=1&idUsuario=${_usuario.id}&idPartida=$idPartida'),
        headers: <String, String>{
          'Authorization': 'Bearer ${_usuario.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('[Buscar pergunta] http status ${uriReponse.statusCode}');
      if (uriReponse.statusCode == 200) {
        var dado = json.decode(uriReponse.body);
        // print(dado);
        return dado['objectsReturn'];
      }
      return null;
    } finally {
      print('[Buscar pergunta] finalizando...');
      client.close();
    }
  }

  static Future<bool> validarRespota2(
      int idEnuciado, int idOpacao, int idPartida) async {
    var client = http.Client();
    try {
      print('[validar resposta] inicilaizado...');
      print(
          '[Validar resposta] http post https://perguntasocoapi.azurewebsites.net/api/pergunta...');
      print('$idEnuciado - $idOpacao - ${_usuario.id} - $idPartida');
      var uriReponse = await client.post(
        Uri.parse('https://perguntasocoapi.azurewebsites.net/api/pergunta'),
        body: jsonEncode({
          "idEnunciado": idEnuciado,
          "idOpcao": idOpacao,
          "idUsuario": _usuario.id,
          "idPartida": idPartida,
        }),
        headers: <String, String>{
          'Authorization': 'Bearer ${_usuario.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('[validar resposta] http status ${uriReponse.statusCode}');
      if (uriReponse.statusCode == 200) {
        var dado = json.decode(uriReponse.body);
        print(
            'resposta: ${dado['objectsReturn']['infoPergunta']['respostaJogadorCorreta']}');
        return dado['objectsReturn']['infoPergunta']['respostaJogadorCorreta'];
      }
      return false;
    } finally {
      print('[validar reposta] finalizando...');
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
        print(dado['objectsReturn']['infoPergunta']['respostaJogador']);
        return dado['objectsReturn']['infoPergunta']['respostaJogador'];
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
          '[Adicionar jogagador] post: ${_getUri('inicio/iniciar-jogo/AdicionarJogador')}...');
      var uriReponse = await client.post(
        Uri.parse(
            'https://perguntasocoapi.azurewebsites.net/api/inicio/adicionar-jogador'),
        body: jsonEncode({
          "idUsuario": _usuario.id,
          "idPartida": idPartida,
        }),
        headers: <String, String>{
          'Authorization': 'Bearer ${_usuario.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('[Adicionar jogagador] http status ${uriReponse.statusCode}');
      if (uriReponse.statusCode == 200) {
        var dado = json.decode(uriReponse.body);
        print(dado);
        if (dado['objectsReturn']['ativa'] = true) {
          print('[Adicionar jogagador] validado api ${uriReponse.statusCode}');
          var jogador = dado['objectsReturn']['infoJogador'];
          _usuario.infoJogador.pontuacao = jogador['porntuacao'];
          _usuario.infoJogador.qtdTapaDado = jogador['qtdTapaDado'];
          _usuario.infoJogador.qtdTapaRecebido = jogador['qtdTapaRecebido'];
          Partida partida = Partida(
            id: idPartida,
            ativa: dado['objectsReturn']['ativa'],
            idCategoriaPerguntas: dado['objectsReturn']['infoPergunta']
                ['idCategoria'],
          );
          print(partida.idCategoriaPerguntas);
          return partida;
        }
      }
      return null;
    } finally {
      print('[Adicionar jogagador] finalizando...');
      client.close();
    }
  }

  static Future<Partida> iniciarPartida(int idCategoria) async {
    var client = http.Client();
    try {
      print(
          '[iniciar jogo] post: https://perguntasocoapi.azurewebsites.net/api/inicio/iniciar-jogo?idUsuario=${_usuario.id}&idCategoria=$idCategoria...');
      var uriReponse = await client.post(
        Uri.parse(
            'https://perguntasocoapi.azurewebsites.net/api/inicio/iniciar-jogo?idUsuario=${_usuario.id}&idCategoria=$idCategoria'),
        headers: <String, String>{
          'Authorization': 'Bearer ${_usuario.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
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

  static Future<bool> verificarAdversarioAcertou() async {
    // Imprementar a rota para verificar se adversario acertou
    await Future.delayed(Duration(seconds: 5));
    return true;
  }

  static Future<bool> vericarVez(int idPartida) async {
    var client = http.Client();
    try {
      print(
          '[verifica vez] get: https://perguntasocoapi.azurewebsites.net/api/pergunta/semaforo/verifica-vez-resposta?idUsuario=${_usuario.id}&idPartida=$idPartida..');
      var uriReponse = await client.get(
        Uri.parse(
            'https://perguntasocoapi.azurewebsites.net/api/pergunta/semaforo/verifica-vez-resposta?idUsuario=${_usuario.id}&idPartida=$idPartida'),
      );
      print('[verificar vez] http status ${uriReponse.statusCode}');
      print('[verificar vez] validado api ${uriReponse.statusCode}');
      if (uriReponse.statusCode == 200) {
        var dado = json.decode(uriReponse.body);
        return dado['objectsReturn']['infoJogador']['vezResponder'];
      }
      return false;
    } finally {
      print('[iniciar partida] finalizando post...');
      client.close();
    }
  }

  static Future<bool> verificarPartidaAtiva(int idPartida) async {
    var client = http.Client();
    try {
      print(
          '[verifica vez] get: https://perguntasocoapi.azurewebsites.net/api/pergunta/semaforo/verifica-partida-ativa?idPartida=$idPartida..');
      var uriReponse = await client.get(
        Uri.parse(
            'https://perguntasocoapi.azurewebsites.net/api/pergunta/semaforo/verifica-partida-ativa?idPartida=$idPartida'),
      );
      print('[verificar ativa] http status ${uriReponse.statusCode}');
      print('[verificar ativa] validado api ${uriReponse.statusCode}');
      if (uriReponse.statusCode == 200) {
        var dado = json.decode(uriReponse.body);
        return dado['objectsReturn']['ativa'];
      }
      return false;
    } finally {
      print('[iniciar partida] finalizando post...');
      client.close();
    }
  }

  static Future<bool> finalizarPartida(int idPartida) async {
    var client = http.Client();
    try {
      print(
          '[finalizar partida] get: https://perguntasocoapi.azurewebsites.net/api/pergunta/semaforo/finaliza-partida?idPartida=$idPartida...');
      var uriReponse = await client.get(
        Uri.parse(
            'https://perguntasocoapi.azurewebsites.net/api/pergunta/semaforo/finaliza-partida?idPartida=$idPartida'),
      );
      print('[finalizar partida] http status ${uriReponse.statusCode}');
      if (uriReponse.statusCode == 200) {
        var dado = json.decode(uriReponse.body);
        return dado['status'];
      }
      return false;
    } finally {
      print('[finalizar partida] finalizando post...');
      client.close();
    }
  }

  static Future<List<Map<String, Object>>> getPartidasOnlie() async {
    var client = http.Client();
    try {
      print(
          '[BUSCAR PARTIDA] GET: https://perguntasocoapi.azurewebsites.net/api/inicio/listar-partidas');
      var uriResponse = await client.get(Uri.parse(
          'https://perguntasocoapi.azurewebsites.net/api/inicio/listar-partidas'));
      print('[BUSCAR PARTIDA] STATUS: ${uriResponse.statusCode}');
      if (uriResponse.statusCode == 200) {
        var dado = json.decode(uriResponse.body);
        List<Map<String, Object>> partidas = [];
        for (var p in dado['objectsReturn']) {
          partidas.add({
            'id': p['idPartida'],
            'nome': p['categoria'],
            'quantidadeParticipantes': p['quantidadeParticipantes'],
            'inicioPartida': p['inicioPartida'],
          });
        }
        return partidas;
      } else {
        print('[BUSCAR PARTIDA] FALHA AO BUSCAR PARTIDA');
        return null;
      }
    } finally {
      print('[BUSCAR PARTIDA] FINALIZADO...');
    }
  }

  static Future<bool> enviarMensagem(String msg, int idPartida) async {
    var client = http.Client();
    try {
      print(
          '[ENVIAR MENSAGEM] GET: https://perguntasocoapi.azurewebsites.net/api/chat/enviar');
      var uriResponse = await client.post(
        Uri.parse('https://perguntasocoapi.azurewebsites.net/api/chat/enviar'),
        body: jsonEncode(
          {
            "idPartida": idPartida,
            "idUsuario": usuario().id,
            "mensagem": msg,
            "destinatario": false,
            "remetente": true,
            "statusChatDTO": {"enviado": true}
          },
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('[ENVIAR MENSAGEM] STATUS: ${uriResponse.statusCode}');
      if (uriResponse.statusCode == 200) {
        var dado = json.decode(uriResponse.body);

        return dado['status'];
      } else {
        print('[ENVIAR MENSAGEM] FALHA AO BUSCAR PARTIDA');
        return false;
      }
    } finally {
      print('[ENVIAR MENSAGEM] FINALIZADO...');
    }
  }

  static Future<List<Map<String, Object>>> recebeMensagens(
      int idPartida) async {
    var client = http.Client();

    try {
      print(
          '[ENVIAR RECEBER] GET: https://perguntasocoapi.azurewebsites.net/api/chat/receber');
      var uriResponse = await client.post(
        Uri.parse('https://perguntasocoapi.azurewebsites.net/api/chat/receber'),
        body: jsonEncode(
          {
            "idPartida": idPartida,
            "idUsuario": usuario().id,
            "mensagem": '',
            "destinatario": true,
            "remetente": false,
            "statusChatDTO": {"enviado": true}
          },
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('[ENVIAR RECEBER] STATUS: ${uriResponse.statusCode}');
      if (uriResponse.statusCode == 200) {
        var dado = json.decode(uriResponse.body);
        List<Map<String, Object>> listaMensagem = [];
        dado['objectsReturn'].forEach((msg) {
          listaMensagem.add(
            {
              'idPartida': msg['idPartida'],
              'idUsuario': msg['idUsuario'],
              'mensagem': msg['mensagem'],
              'dataHora': msg['dataHoraEnvio'],
            },
          );
        });
        return listaMensagem;
      } else {
        print('[ENVIAR RECEBER] FALHA AO BUSCAR PARTIDA');
        return null;
      }
    } finally {
      print('[ENVIAR RECEBER] FINALIZADO...');
    }
  }
}

// main() async {
//   var partidasOnlie = ApiBanco.getPartidasOnlie();
//   print(partidasOnlie);
// }
