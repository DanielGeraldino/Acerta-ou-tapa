import 'package:acerta_ou_tapa/utilities/api_banco.dart';
import 'package:acerta_ou_tapa/utilities/button_login.dart';
import 'package:acerta_ou_tapa/utilities/text_input_login.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  TextEditingController controllerUsuario;
  TextEditingController controllerSenha;
  final focusNodeUsuario = FocusNode();
  final focusNodeSenha = FocusNode();

  @override
  void initState() {
    controllerUsuario = TextEditingController();
    controllerSenha = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controllerUsuario.dispose();
    controllerSenha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/logo.jpg',
                height: 200,
              ),
              TextInputLogin(
                size: size,
                controller: controllerUsuario,
                focusNode: focusNodeUsuario,
                nextFocusNode: focusNodeSenha,
                hintText: 'Digite seu usuario',
                labelText: 'Digite seu usuario',
                icon: Icon(Icons.person_rounded),
                obscureText: false,
              ),
              SizedBox(height: 20),
              TextInputLogin(
                controller: controllerSenha,
                focusNode: focusNodeSenha,
                nextFocusNode: null,
                size: size,
                hintText: "Digite sua senha",
                labelText: 'Digite sua senha',
                icon: Icon(Icons.lock_clock),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ButtonLogin(
                width: size.width * .8,
                height: size.height * .05,
                title: 'ENTRAR',
                onPressed: () async {
                  ApiBanco.setUsuario(controllerUsuario.text);
                  ApiBanco.setSenha(controllerSenha.text);
                  await ApiBanco.setToken();
                  if (ApiBanco.status) {
                    Navigator.pushNamed(context, '/catalago');
                  } else {
                    Toast.show('FAVOR VERIFICAR SENHA', context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
