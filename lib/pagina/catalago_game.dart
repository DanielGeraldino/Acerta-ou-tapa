import 'dart:convert';
import 'dart:typed_data';

import 'package:acerta_ou_tapa/model/pergunta.dart';
import 'package:acerta_ou_tapa/pagina/card_game.dart';
import 'package:acerta_ou_tapa/utilities/AlertDialogBluetooth.dart';
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

  void _connect() async {
    if (!_connected) {
      await BluetoothConnection.toAddress(_device.address).then((_connection) {
        print('Conectado com ${_device.name}');
        connection = _connection;
        setState(() {
          _connected = true;
        });
        connection.input.listen(null).onDone(() {
          if (isDisconnecting) {
            print('Desconectado localmente!');
          } else {
            print('Desconectado remotamente!');
          }
          if (this.mounted) {
            setState(() {});
          }
        });
      }).catchError((error) {
        print('erro na conectacao bluetooth');
        print(error);
      });
    }
  }

  void enviarMensagem(String texto) async {
    texto = texto.trim();
    if (texto.isNotEmpty) {
      try {
        connection.output.add(utf8.encode((texto + "\r\n")));
        await connection.output.allSent;
      } catch (e) {}
    }
  }

  void setDevice(BluetoothDevice device) {
    setState(() {
      _device = device;
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
    // Closing the Bluetooth connection
    await connection.close();

    // Update the [_connected] variable
    if (!connection.isConnected) {
      setState(() {
        _connected = false;
      });
    }
  }

  void mostrarDispositivos(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext builder) => AlertDialogBluetooth(
        // deviceSelecionado: _device,
        listaDispositivo: _devicesList,
        setDevoceSelecionado: setDevice,
        connectDevice: _connect,
        eventoConectar: () {
          Navigator.pop(context);
        },
      ),
    );
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

    // habilitaBluetooth();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerta ou Leva Tapa'),
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
          Card(
            clipBehavior: Clip.antiAlias,
            elevation: 3,
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
                            mostrarDispositivos(context);
                          } else {
                            await FlutterBluetoothSerial.instance
                                .requestDisable();
                            setDevice(null);
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
                    )
                  ],
                ),
                _device != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Dispositivo: ${_device.name}",
                              style: TextStyle(fontSize: 17)),
                          RaisedButton(
                            color: _connected ? Colors.red : Colors.green,
                            onPressed: _connected ? _disconnect : _connect,
                            child: isConnection
                                ? Text(
                                    "CONECTADO",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Text(
                                    "CONECTAR",
                                    style: TextStyle(color: Colors.white),
                                  ),
                          )
                        ],
                      )
                    : Text(""),
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
