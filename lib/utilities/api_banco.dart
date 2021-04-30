import 'dart:convert';
import 'package:acerta_ou_tapa/model/categoria.dart';

import 'package:http/http.dart' as http;

class ApiBanco {
  String _usuario;
  String _senha;
  String _token;
  bool status = false;
  final _url = Uri.parse('https://perguntasocoapi.azurewebsites.net/api/login');

  ApiBanco(this._usuario, this._senha);

  get user {
    return this._usuario;
  }

  set usuario(String usuario) {
    _usuario = user;
  }

  set senha(String senha) {
    _senha = senha;
  }

  get token {
    return this._token;
  }

  void logout() {
    this.status = false;
    this.usuario = '';
    this.senha = '';
  }

  Uri _getUri(String agr) {
    return Uri.parse('https://perguntasocoapi.azurewebsites.net/api/$agr');
  }

  Future<bool> setToken() async {
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
        this._token = dado['description'];
        this.status = dado['status'];
        return this.status;
      }
      return this.status;
    } finally {
      client.close();
    }
  }

  Future<List> getCategorias() async {
    var client = http.Client();
    try {
      var uriReponse = await client.get(
        _getUri('categoria/?pagina=1&quantidade=5'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
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

// main() async {
//   var teste = ApiBanco('Admin', 'Admin123');
//   await teste.setToken();
//   var perguntas = await teste.getCategorias();
//   print(perguntas[0]);
// }
