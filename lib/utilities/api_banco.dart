import 'dart:convert';
import 'package:acerta_ou_tapa/model/categoria.dart';

import 'package:http/http.dart' as http;

class ApiBanco {
  static String _usuario;
  static String _senha;
  static String _token;
  static bool status = false;
  static final _url =
      Uri.parse('https://perguntasocoapi.azurewebsites.net/api/login');

  // ApiBanco(this._usuario, this._senha);

  static setUsuario(String u) {
    _usuario = u;
  }

  static setSenha(String s) {
    _senha = s;
  }

  static getToken() {
    return _token;
  }

  static logout() {
    status = false;
    _usuario = null;
    _senha = null;
  }

  static Uri _getUri(String agr) {
    return Uri.parse('https://perguntasocoapi.azurewebsites.net/api/$agr');
  }

  static Future<bool> setToken() async {
    var client = http.Client();
    try {
      var uriReponse = await client.post(_getUri('login'),
          body: jsonEncode(<String, String>{
            "Username": "$_usuario",
            "Password": "$_senha",
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      if (uriReponse.statusCode == 200) {
        var dado = json.decode(uriReponse.body);
        _token = dado['description'];
        status = dado['status'];
        return status;
      }
      return status;
    } finally {
      client.close();
    }
  }

  static Future<List> getCategorias() async {
    var client = http.Client();
    try {
      var uriReponse = await client.get(
        _getUri('categoria/?pagina=1&quantidade=5'),
        headers: <String, String>{
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (uriReponse.statusCode == 200) {
        var dado = json.decode(uriReponse.body);
        return dado['objectsReturn'];
      }
      return null;
    } finally {
      client.close();
    }
  }

  static Future<List> getPergunta(int idCategoria) async {
    var client = http.Client();
    try {
      var uriReponse = await client.get(
        _getUri('pergunta?idCategoria=$idCategoria'),
        headers: <String, String>{
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (uriReponse.statusCode == 200) {
        var dado = json.decode(uriReponse.body);
        return dado['objectsReturn'];
      }
      return null;
    } finally {
      client.close();
    }
  }
}

main() async {
  ApiBanco.setUsuario('admin');
  ApiBanco.setSenha('admin123');
  var teste = await ApiBanco.getPergunta(1) as List;
  print(teste[0]['listaOpcoes']);
}
