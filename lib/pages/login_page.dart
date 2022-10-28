import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:todolist_flutter/componentes/botao.dart';
import 'package:todolist_flutter/componentes/message_dialog.dart';
import 'package:todolist_flutter/main.dart';
import 'package:todolist_flutter/services/auth_service.dart';

class LoginPage extends StatelessWidget {

  BuildContext? context = null;

  AuthService get _authService => GetIt.instance<AuthService>();

  late TextEditingController _controllerEmail = TextEditingController();
  late TextEditingController _controllerSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SingleChildScrollView(
          child: Card(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 30, bottom: 0),
                  child: TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'E-mail',
                        hintText: 'abc@gmail.com'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: _controllerSenha,
                    obscureText: true,
                    onSubmitted: (value) {
                      _login();
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Senha',
                        hintText: 'Entre com a senha'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 15),
                  child: Botao('OK', _login),
                )
              ],
            ),
          )),
    );
  }

  void _login() {
    if (validateFields()) {
      String email = _controllerEmail.value.text;
      String senha = _controllerSenha.value.text;

      _authService.autentica(email, senha).then((value) =>
          Navigator.push(context!, MaterialPageRoute(builder: (_) => App()))
      ).catchError((e) =>
          MessageDialog.showMessageError(context!, "E-mail/senha inválidos"));
    }
  }

  bool validateFields() {
    String email = _controllerEmail.value.text;
    String senha = _controllerSenha.value.text;

    if (email.trim().length == 0) {
      MessageDialog.showMessageError(context!, "O campo E-mail deve ser preenchido");
      return false;
    }

    if (!RegExp(r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$")
        .hasMatch(email)) {
      MessageDialog.showMessageError(context!, "E-mail inválido");
      return false;
    }

    if (senha.trim().length == 0) {
      MessageDialog.showMessageError(context!, "O campo Senha deve ser preenchido");
      return false;
    }

    return true;
  }

}
