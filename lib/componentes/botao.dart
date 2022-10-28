import 'package:flutter/material.dart';

class Botao extends StatelessWidget {

  final String label;
  final Function onPressed;

  Botao(this.label, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 100,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        child: Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}