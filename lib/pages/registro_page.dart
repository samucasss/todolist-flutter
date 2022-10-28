import 'package:flutter/material.dart';
import 'package:todolist_flutter/models/usuario.dart';
import 'package:todolist_flutter/pages/usuario_page.dart';

class RegistroPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Registro de usuário"),
        ),
        body: SingleChildScrollView(
          child: UsuarioPage(Usuario(id: null, nome: '', email: '')),
        )
    );
  }

}