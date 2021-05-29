import 'package:flutter/material.dart';

@immutable
class CardGameWidget extends StatelessWidget {
  String _title;
  String _subtitle;
  void Function() _onPress;

  CardGameWidget(this._title, this._subtitle, this._onPress);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      child: Column(
        children: [
          ListTile(
            title: Text(this._title),
            subtitle: Text(
              this._subtitle,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => this._onPress(),
                child: const Text('ENTRAR'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
