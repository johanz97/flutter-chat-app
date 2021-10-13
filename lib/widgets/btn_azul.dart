import 'package:flutter/material.dart';

class BtnAzul extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  const BtnAzul({Key? key, required this.text, required this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(2),
            shape: MaterialStateProperty.all(const StadiumBorder())),
        onPressed: onPressed,
        child: Container(
          margin:
              const EdgeInsets.only(top: 15, bottom: 15, left: 5, right: 20),
          child: Center(
              child: Text(
            text,
            style: const TextStyle(fontSize: 17),
          )),
        ));
  }
}
