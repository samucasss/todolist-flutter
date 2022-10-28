import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:todolist_flutter/componentes/botao.dart';
import 'package:todolist_flutter/componentes/message_dialog.dart';
import 'package:todolist_flutter/main.dart';
import 'package:todolist_flutter/models/usuario.dart';
import 'package:todolist_flutter/services/auth_service.dart';
import 'package:todolist_flutter/services/usuario_service.dart';

class UsuarioPage extends StatelessWidget {
  BuildContext? context = null;

  AuthService get _authService => GetIt.instance<AuthService>();

  UsuarioService get _usuarioService => GetIt.instance<UsuarioService>();

  final Usuario _usuario;

  late TextEditingController _controllerNome = TextEditingController();
  late TextEditingController _controllerEmail = TextEditingController();
  late TextEditingController _controllerSenha = TextEditingController();

  UsuarioPage(this._usuario);

  @override
  Widget build(BuildContext context) {
    this.context = context;

    if (_usuario != null) {
      _controllerNome.text = _usuario.nome;
      _controllerEmail.text = _usuario.email;
    }

    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Card(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextField(
              controller: _controllerNome,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome',
                  hintText: 'Entre com o nome'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
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
              onSubmitted: (value) {},
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Senha',
                  hintText: 'Entre com a senha'),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Botao('OK', _ok),
                  if (_usuario.id != null)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 15),
                      child: Botao('Excluir', _confirmDelete)
                    )
                ],
              )),
        ],
      ),
    );
  }

  bool _validateFields() {
    String nome = _controllerNome.value.text;
    String email = _controllerEmail.value.text;
    String senha = _controllerSenha.value.text;

    if (nome.trim().length == 0) {
      MessageDialog.showMessageError(
          context!, "O campo Nome deve ser preenchido");
      return false;
    }

    if (email.trim().length == 0) {
      MessageDialog.showMessageError(
          context!, "O campo E-mail deve ser preenchido");
      return false;
    }

    if (!RegExp(r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$")
        .hasMatch(email)) {
      MessageDialog.showMessageError(context!, "E-mail inválido");
      return false;
    }

    if (senha.trim().length == 0) {
      MessageDialog.showMessageError(
          context!, "O campo Senha deve ser preenchido");
      return false;
    }

    return true;
  }

  void _ok() {
    if (_validateFields()) {
      String nome = _controllerNome.value.text;
      String email = _controllerEmail.value.text;
      String senha = _controllerSenha.value.text;
      String? id = _usuario.id != null ? _usuario.id : null;

      Usuario usuario = Usuario(id: id, nome: nome, email: email, senha: senha);

      if (usuario.id == null) {
        _register(usuario);
      } else {
        _save(usuario);
      }
    }
  }

  void _register(Usuario usuario) {
    _authService
        .register(usuario)
        .then((value) => _authService
                .autentica(usuario.email, usuario.senha)
                .then((value) {
              Navigator.push(
                  context!, MaterialPageRoute(builder: (_) => App()));

              MessageDialog.showMessageSucesso(context!);
            }).catchError((e) => MessageDialog.showMessageError(
                    context!, "E-mail/senha inválidos")))
        .catchError((e) => MessageDialog.showMessageError(
            context!, "Erro ao registrar usuário"));
  }

  void _save(Usuario usuario) {
    _usuarioService.save(usuario).then((value) {
      _authService.updateUser(usuario);

      Navigator.pushReplacement(
          context!, MaterialPageRoute(builder: (_) => App()));

      MessageDialog.showMessageSucesso(context!);
    }).catchError((e) =>
        MessageDialog.showMessageError(context!, "E-mail/senha inválidos"));
  }

  void _confirmDelete() {
    MessageDialog.showConfirmationDialog(
        context!,
        "Tem certeza que deseja excluir seu registro do sistema?",
        _delete);
  }

  void _delete() {
    _usuarioService.delete().then((value) {
      _authService.deleteUser();

      Navigator.pushReplacement(
          context!, MaterialPageRoute(builder: (_) => App()));

      MessageDialog.showMessageSucesso(context!);
    });
  }
}
