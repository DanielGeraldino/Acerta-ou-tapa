import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  TextEditingController controllerUsuario;
  TextEditingController controllerSenha;

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
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'images/logo.jpg',
                height: 150,
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
                child: TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Digite seu usuario',
                    labelText: 'Digite seu usuario',
                  ),
                  controller: controllerUsuario,
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 20),
                child: TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock_open),
                    hintText: 'Digite sua senha',
                    labelText: 'Digite sua senha',
                  ),
                  controller: controllerSenha,
                  obscureText: true,
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 20),
                child: ElevatedButton(
                  child: Text('ENTRAR'),
                  onPressed: () => Navigator.pushNamed(context, '/catalago'),
                ),
              ),
              Text('Novo jogador? click para criar conta.'),
            ],
          )),
    );
  }
}
