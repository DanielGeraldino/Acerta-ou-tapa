import 'package:acerta_ou_tapa/model/pergunta.dart';
import 'package:acerta_ou_tapa/pagina/card_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../utilities/api_banco.dart';

class CatalagoGameWidget extends StatefulWidget {
  @override
  _CatalagoGameWidgetState createState() => _CatalagoGameWidgetState();
}

class _CatalagoGameWidgetState extends State<CatalagoGameWidget> {
  //Lista de categorias de perguntas
  List categorias = [];
  //Guarda status do bluetooth
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  //Pega a instancia do bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  //Ratreia conexão com device
  BluetoothConnection connection;

  bool isDisconnecting = false;

  int _deviceState;

  bool get isConnection => connection != null && connection.isConnected;

  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;

  void atualizaCategorias() async {
    var auxCat = await ApiBanco.getCategorias();
    setState(() {
      categorias = auxCat;
    });
  }

  @override
  void initState() {
    super.initState();
    //Busca categorias na api
    atualizaCategorias();

    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0;

    habilitaBluetooth();

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getDispositivosPareados();
      });
    });
  }

  Future<void> habilitaBluetooth() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getDispositivosPareados();
      return true;
    } else {
      await getDispositivosPareados();
    }
    return false;
  }

  Future<void> getDispositivosPareados() async {
    List<BluetoothDevice> devices = [];
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print('error');
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _devicesList = devices;
    });
  }

  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      _deviceState = 0;
    });

    await connection.close();
    // show('Device disconnected');
    if (!connection.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItem() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(child: Text('VAZIO')));
    } else {
      _devicesList.forEach(
        (device) {
          items.add(
            DropdownMenuItem(
              child: Text(device.name),
              value: device,
            ),
          );
        },
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerta ou leva tapa'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                ApiBanco.logout();
                Navigator.popUntil(
                  context,
                  ModalRoute.withName('/login'),
                );
              })
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Habilitar Bluetooth",
                      style: TextStyle(fontSize: 18),
                    ),
                    Switch(
                      value: _bluetoothState.isEnabled,
                      onChanged: (value) {
                        future() async {
                          if (value) {
                            await FlutterBluetoothSerial.instance
                                .requestEnable();
                          } else {
                            await FlutterBluetoothSerial.instance
                                .requestDisable();
                          }

                          await getDispositivosPareados();
                          _isButtonUnavailable = false;

                          if (_connected) {
                            _disconnect();
                          }
                        }

                        future().then((_) {
                          setState(() {});
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Selecionar dispositivo',
                      style: TextStyle(fontSize: 18),
                    ),
                    DropdownButton(
                      items: _getDeviceItem(),
                      value: _devicesList.isEmpty ? _device : null,
                      elevation: 16,
                      onChanged: (value) {
                        setState(() {
                          print(value.name);
                          _device = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          for (var i in categorias)
            if (i['nome'] != null && i['descricao'] != null)
              CardGameWidget(
                i['nome'],
                i['descricao'],
                () => Navigator.pushNamed(
                  context,
                  '/game',
                  arguments: i['idCategoria'] as int,
                ),
              ),
        ],
      ),
    );
  }
}
