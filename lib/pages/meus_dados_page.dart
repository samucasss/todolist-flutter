import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:todolist_flutter/models/usuario.dart';
import 'package:todolist_flutter/models/usuario_sessao.dart';
import 'package:todolist_flutter/pages/usuario_page.dart';
import 'package:todolist_flutter/services/auth_service.dart';


class MeusDadosPage extends StatelessWidget {

  AuthService get _authService => GetIt.instance<AuthService>();

  @override
  Widget build(BuildContext context) {
    UsuarioSessao? usuarioSessao = _authService.getUser();
    Usuario usuario = Usuario(id: usuarioSessao?.id, nome: usuarioSessao!.nome, email: usuarioSessao!.email);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Meus dados"),
        ),
        body: SingleChildScrollView(
          child: UsuarioPage(usuario),
        )
    );
  }

}