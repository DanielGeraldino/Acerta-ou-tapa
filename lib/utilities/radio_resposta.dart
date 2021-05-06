import 'package:flutter/material.dart';

class RadioResposta extends StatelessWidget {
  final value;
  final groupValue;
  final Function(dynamic) onChanged;
  final title;

  RadioResposta({
    @required this.value,
    @required this.groupValue,
    @required this.onChanged,
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) onChanged(value);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Radio(
              value: value,
              groupValue: groupValue,
              onChanged: (b) {
                this.onChanged(b);
              },
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.justify,
              ),
            )
          ],
        ),
      ),
    );
  }
}
