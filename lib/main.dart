import 'package:flutter/material.dart';
import 'package:todolist_flutter/componentes/toolbar.dart';
import 'package:get_it/get_it.dart';
import 'package:todolist_flutter/pages/tarefa_list_page.dart';
import 'package:todolist_flutter/services/auth_service.dart';
import 'package:todolist_flutter/services/preferencias_service.dart';
import 'package:todolist_flutter/services/tarefa_service.dart';
import 'package:todolist_flutter/services/tecnologia_service.dart';
import 'package:todolist_flutter/services/usuario_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void serviceLocator() {
  GetIt.instance.registerLazySingleton(() => AuthService());
  GetIt.instance.registerLazySingleton(() => TecnologiaService());
  GetIt.instance.registerLazySingleton(() => UsuarioService());
  GetIt.instance.registerLazySingleton(() => PreferenciasService());
  GetIt.instance.registerLazySingleton(() => TarefaService());
}

void main() {
  serviceLocator();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)  {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      title: 'ToDoList',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TarefaListPage(),
    );
  }
}

