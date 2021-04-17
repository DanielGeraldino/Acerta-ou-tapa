import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiBanco {
  String _user;
  String _senha;
  String _token;
  var _url = Uri.parse('https://perguntasocoapi.azurewebsites.net/api/login');

  ApiBanco(this._user, this._senha);

  get user {
    return this.user;
  }

  get token {
    return this._token;
  }

  Future<void> setToken() async {
    var client = http.Client();
    try {
      var uriReponse = await client.post(this._url,
          body: jsonEncode(<String, String>{
            "Username": "$_user",
            "Password": "$_senha",
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      if (uriReponse.statusCode == 200) {
        var dado = json.decode(uriReponse.body);
        this._token = dado['description'];
        print(this.token);
      }
    } finally {
      client.close();
    }
  }
}
