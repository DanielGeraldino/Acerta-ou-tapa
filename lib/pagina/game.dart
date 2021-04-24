import 'package:acerta_ou_tapa/model/pergunta.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class GameWidget extends StatefulWidget {
  @override
  _GameWidgetState createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  Pergunta pergunta = Pergunta(
    'Pegunta teste:',
    1,
    [
      'resp1',
      'resp2',
      'resp3',
      'resp4',
    ],
  );

  var selecionado = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Acerta ou leva tapa'),
        ),
        body: Column(
          children: [
            Text(
              pergunta.titulo,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            for (int i = 0; i < 4; i++)
              Row(
                children: [
                  Radio(
                    value: i,
                    groupValue: selecionado,
                    onChanged: (resp) {
                      setState(() {
                        selecionado = resp;
                      });
                    },
                  ),
                  Text(pergunta.possivelRespota[i]),
                ],
              ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 20),
              child: ElevatedButton(
                child: Text('PROXIMO'),
                onPressed: () {
                  Toast.show(
                    '${pergunta.possivelRespota[selecionado]}',
                    context,
                  );
                  Navigator.pushNamed(context, '/game_final');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
