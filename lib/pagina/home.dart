import 'package:acerta_ou_tapa/utilities/AlertDialogBluetooth.dart';
import 'package:acerta_ou_tapa/utilities/Bluetooth.dart';
import 'package:acerta_ou_tapa/utilities/api_banco.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var widthButton;

  Bluetooth controleBlue;
  bool iniciadoBlue;

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (controleBlue.devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      controleBlue.devicesList.forEach((device) {
        print(device.name);
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    widthButton = MediaQuery.of(context).size.width * .6;
    print('é nulo: ${controleBlue == null}');
    if (controleBlue == null) {
      controleBlue = Provider.of<Bluetooth>(context);
      controleBlue.init();
    }
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/logo.png',
                height: 300,
              ),
              ButtonHome(
                titulo: 'CRIAR PARTIDA',
                width: widthButton,
                onPress: () => {
                  Navigator.pushNamed(context, '/catalago'),
                },
              ),
              ButtonHome(
                titulo: 'ACESSAR PARTIDA',
                width: widthButton,
                onPress: () {
                  Navigator.pushNamed(context, '/acessa_partida');
                },
              ),
              ButtonHome(
                titulo: 'BLUETOOTH',
                width: widthButton,
                style:
                    ElevatedButton.styleFrom(primary: controleBlue.colorButton),
                onPress: () {
                  if (controleBlue.bluetoothState == BluetoothState.STATE_ON) {
                    controleBlue.disconnect();
                  } else {
                    controleBlue.enableBluetooth();
                  }
                },
              ),
              ButtonHome(
                titulo: 'TESTAR TAPA',
                width: widthButton,
                onPress: () {
                  controleBlue.sendOnMessageToBluetooth();
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton(
                    items: _getDeviceItems(),
                    onChanged: (value) {
                      setState(() {
                        controleBlue.device = value;
                        controleBlue.connectDevice();
                      });
                    },
                    value: controleBlue.devicesList.isNotEmpty
                        ? controleBlue.device
                        : null,
                  ),
                  CircleAvatar(
                    radius: 7.0,
                    backgroundColor:
                        controleBlue.isConnected ? Colors.green : Colors.red,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonHome extends StatelessWidget {
  final titulo;
  final onPress;
  final width;
  final heith;
  final style;

  ButtonHome({
    this.titulo,
    this.onPress,
    this.width,
    this.heith,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: width,
      // height: heith,
      child: ElevatedButton(
        style: style,
        onPressed: () => onPress(),
        child: Text("$titulo"),
      ),
    );
  }
}
