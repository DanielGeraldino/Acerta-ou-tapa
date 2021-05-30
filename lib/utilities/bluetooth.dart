import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Bluetooth extends ChangeNotifier {
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection connection;
  List<BluetoothDevice> devicesList = [];
  BluetoothDevice _device;
  Color _colorStatusButtonBlue;

  bool _connected = false;
  bool isDisconnecting = false;
  bool get isConnected => connection != null && connection.isConnected;

  get colorButton {
    setStatusButtonBluetooth();
    return _colorStatusButtonBlue;
  }

  set device(BluetoothDevice d) {
    this._device = d;
    notifyListeners();
  }

  get device => this._device;

  init() {
    FlutterBluetoothSerial.instance.state.then((state) {
      bluetoothState = state;
    });

    enableBluetooth();

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      bluetoothState = state;
      getPairedDevices();
    });
  }

  Future<void> enableBluetooth() async {
    bluetoothState = await FlutterBluetoothSerial.instance.state;

    if (bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    setStatusButtonBluetooth();
    return false;
  }

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }
    devicesList = devices;
    notifyListeners();
  }

  void disconnect() async {
    // await connection.close();
    devicesList.clear();
    FlutterBluetoothSerial.instance.requestDisable();
    if (!connection.isConnected) {
      _connected = false;
    }
    notifyListeners();
  }

  void connectDevice() async {
    if (_device != null) {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device.address)
            .then((_connection) {
          print('Connected to the device');
          connection = _connection;
          _connected = true;
          connection.input.listen(null).onDone(() {
            if (isDisconnecting) {
              print('Disconnecting locally!');
            } else {
              print('Disconnected remotely!');
            }
          });
        }).catchError((error) {
          print('Cannot connect, exception occurred');
          print(error);
        });
      }
    }
    notifyListeners();
  }

  void disconnectDevice() async {
    await connection.close();
    if (!connection.isConnected) {
      _connected = false;
    }
  }

  void sendOnMessageToBluetooth() async {
    connection.output.add(utf8.encode("1" + "\r\n"));
    await connection.output.allSent;
  }

  void sendOffMessageToBluetooth() async {
    connection.output.add(utf8.encode("0" + "\r\n"));
    await connection.output.allSent;
  }

  void setStatusButtonBluetooth() {
    if (BluetoothState.STATE_ON == bluetoothState) {
      _colorStatusButtonBlue = Colors.green;
    } else {
      _colorStatusButtonBlue = Colors.red;
    }
  }
}
