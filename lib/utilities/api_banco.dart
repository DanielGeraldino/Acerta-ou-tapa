import 'dart:convert';

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

  Future<void> setToken() async {
    var client = http.Client();
    try {
      var uriReponse = await client.post(this._url,
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
        print(this.status);
      }
    } finally {
      client.close();
    }
  }
}

// main() {
//   var teste = ApiBanco('admin', 'admin123456');
//   teste.setToken();
// }
