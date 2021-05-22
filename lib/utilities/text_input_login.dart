import 'package:flutter/material.dart';

class TextInputLogin extends StatelessWidget {
  TextEditingController controller;
  FocusNode focusNode;
  FocusNode nextFocusNode;
  Icon icon;
  String hintText;
  String labelText;
  Size size;
  bool obscureText;
  TextInputAction textInputAction;

  TextInputLogin({
    @required this.controller,
    @required this.focusNode,
    @required this.nextFocusNode,
    @required this.size,
    @required this.hintText,
    @required this.labelText,
    @required this.icon,
    @required this.obscureText,
    this.textInputAction = TextInputAction.next,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * .8,
      decoration: BoxDecoration(
        color: Colors.white,
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
      // margin: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
      child: TextFormField(
        textInputAction: textInputAction,
        obscureText: obscureText,
        decoration: InputDecoration(
          icon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: icon,
          ),
          hintText: hintText,
          labelText: labelText,
          border: InputBorder.none,
        ),
        controller: controller,
        focusNode: focusNode,
        onFieldSubmitted: (term) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        },
      ),
    );
  }
}
