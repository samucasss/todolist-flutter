import 'package:flutter/material.dart';

class MessageDialog {
  static void showMessageSucesso(BuildContext context) {
    _showMessageSucess(context, "Operação realizada com sucesso");
  }

  static void showMessageError(BuildContext context, String message) {
    _showMessageError(context, message);
  }

  static void _showMessageSucess(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message, style: TextStyle(color: Color(0xff155724))),
          backgroundColor: Color(0xffd4edda)));
  }

  static void _showMessageError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message, style: TextStyle(color: Color(0xff721c24))),
        backgroundColor: Color(0xfff8d7da)));
  }

  static void showConfirmationDialog(BuildContext context, String message, Function success) {  // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancelar"),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = TextButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        success();
      },
    );  // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(message),
      actions: [
        cancelButton,
        continueButton,
      ],
    );  // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
