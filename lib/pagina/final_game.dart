import 'package:flutter/material.dart';

class GameFinalizaWidget extends StatefulWidget {
  @override
  _GameFinalizaWidgetState createState() => _GameFinalizaWidgetState();
}

class _GameFinalizaWidgetState extends State<GameFinalizaWidget> {
  var _valueSlider = 0.0;

  @override
  Widget build(BuildContext context) {
    var pergAcertou = ModalRoute.of(context).settings.arguments as bool;
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerta ou tapa na cara'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Parabens!',
            style: TextStyle(fontSize: 30),
          ),
          Container(
            child: ElevatedButton(
              child: Text('PREPARAR'),
              onPressed: () {
                // to-do: se acerta prepara a amofada, se não leva o tapa
                print(pergAcertou);
                Navigator.pop(context);
              },
            ),
          ),
          Column(
            children: [
              Text(
                'Nível de força do tapinha:',
                style: TextStyle(fontSize: 20),
              ),
              Slider(
                value: _valueSlider,
                onChanged: (newValue) {
                  setState(() {
                    _valueSlider = newValue;
                  });
                },
                label: '${_valueSlider.round()}',
                max: 100,
                min: 0,
              )
            ],
          )
        ],
      ),
    );
  }
}
