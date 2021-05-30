import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class AlertDialogBluetooth extends StatefulWidget {
  List<BluetoothDevice> listaDispositivo;
  BluetoothDevice deviceSelecionado;
  void Function(BluetoothDevice) setDeviceSelecionado;
  void Function() connectDevice;
  BluetoothDevice Function() eventoConectar;

  AlertDialogBluetooth({
    this.setDeviceSelecionado,
    this.listaDispositivo,
    this.deviceSelecionado,
    this.eventoConectar,
    this.connectDevice,
  });

  @override
  _AlertDialogBluetoothState createState() => _AlertDialogBluetoothState();
}

class _AlertDialogBluetoothState extends State<AlertDialogBluetooth> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Selecione um dispositivo: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            if (widget.listaDispositivo.isEmpty)
              Text('Nenhum dispositivo encontrado. Tente reniciar o bluetooth')
            else
              for (BluetoothDevice dv in widget.listaDispositivo)
                ListTile(
                  title: Text(dv.name),
                  subtitle: Text(dv.address),
                  onTap: () {
                    setState(() {
                      widget.deviceSelecionado = dv;
                    });
                  },
                ),
            if (widget.deviceSelecionado != null)
              Text('Selecionado: ${widget.deviceSelecionado.name}'),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                  onPressed: () {
                    if (widget.deviceSelecionado != null) {
                      widget.eventoConectar();
                      widget.setDeviceSelecionado(widget.deviceSelecionado);
                      widget.connectDevice();
                      return widget.deviceSelecionado;
                    }
                    return null;
                  },
                  child: Text('SELECIONAR')),
            ),
          ],
        ),
      ),
    );
  }
}
