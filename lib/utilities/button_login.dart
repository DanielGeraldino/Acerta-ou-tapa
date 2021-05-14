import 'package:flutter/material.dart';

class ButtonLogin extends StatelessWidget {
  var width;
  var height;
  var title;
  void Function() onPressed;

  ButtonLogin({
    this.width,
    this.height,
    this.title,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: .5,
              blurRadius: 7,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: ElevatedButton(
          child: Text('$title'),
          onPressed: () => onPressed(),
        ));
  }
}