import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:todolist_flutter/main.dart';
import 'package:todolist_flutter/models/usuario_sessao.dart';
import 'package:todolist_flutter/pages/login_page.dart';
import 'package:todolist_flutter/pages/meus_dados_page.dart';
import 'package:todolist_flutter/pages/preferencias_page.dart';
import 'package:todolist_flutter/pages/registro_page.dart';
import 'package:todolist_flutter/pages/tecnologia_page.dart';
import 'package:todolist_flutter/services/auth_service.dart';

class Toolbar extends StatefulWidget implements PreferredSizeWidget {
  Toolbar();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  _ToolbarState createState() => _ToolbarState();
}

class _ToolbarState extends State<Toolbar> {
  bool isLogged = false;

  _ToolbarState();

  AuthService get _authService => GetIt.instance<AuthService>();

  @override
  void initState() {
    _authService.readUser().then((value) => setState(() {
          isLogged = _authService.isLogged();
        }));
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("ToDoList"),
      leading: Icon(Icons.home),
      actions: _authService.isLogged()
          ? _menusUsuarioLogado(context)
          : _menusUsuarioNaoLogado(context),
    );
  }

  List<Widget> _menusUsuarioNaoLogado(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.list),
        tooltip: 'Tecnologias',
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => TecnologiaPage()));
        },
      ),
      IconButton(
        icon: const Icon(Icons.app_registration),
        tooltip: 'Registre-se',
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => RegistroPage()));
        },
      ),
      IconButton(
        icon: const Icon(Icons.login),
        tooltip: 'Login',
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => LoginPage()));
        },
      ),
    ];
  }

  List<Widget> _menusUsuarioLogado(BuildContext context) {
    UsuarioSessao? usuarioSessao = _authService.getUser();
    String userName = usuarioSessao != null ? usuarioSessao.nome : '';

    return [
      AppBarSearchButton(toolTipStartText: 'Clique para pesquisar', toolTipLastText: 'Pesquisar',),
      IconButton(
        icon: const Icon(Icons.task),
        tooltip: 'Tarefas',
        onPressed: () {},
      ),
      IconButton(
        icon: const Icon(Icons.manage_accounts),
        tooltip: 'Preferências',
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => PreferenciasPage()));
        },
      ),
      PopupMenuButton(
          tooltip: userName,
          icon: Icon(Icons.account_circle),
          itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                value: 0,
                child: Text("Meus dados"),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text("Sair"),
              ),
            ];
          },
          onSelected: (value) {
            if (value == 0) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => MeusDadosPage()));
            } else if (value == 1) {
              _authService.logout().then((value) {
                setState(() {
                  isLogged = false;
                });

                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => App()));
              });
            }
          }),
    ];
  }
}
