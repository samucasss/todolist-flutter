import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:todolist_flutter/componentes/toolbar.dart';
import 'package:todolist_flutter/models/preferencias.dart';
import 'package:todolist_flutter/models/tarefa.dart';
import 'package:todolist_flutter/models/tipo_filtro.dart';
import 'package:todolist_flutter/pages/tarefa_page.dart';
import 'package:todolist_flutter/services/auth_service.dart';
import 'package:todolist_flutter/services/preferencias_service.dart';
import 'package:todolist_flutter/services/tarefa_service.dart';
import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';

class TarefaListPage extends StatefulWidget {
  @override
  _TarefaListState createState() => _TarefaListState();
}

class _TarefaListState extends State<TarefaListPage> {
  AuthService get _authService => GetIt.instance<AuthService>();
  PreferenciasService get _preferenciasService => GetIt.instance<PreferenciasService>();
  TarefaService get _service => GetIt.instance<TarefaService>();

  bool _isLogged = false;
  String _search = '';

  @override
  void initState() {
    _authService.readUser().then((value) => setState(() {
          _isLogged = _authService.isLogged();
        }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBarWithSearchSwitch(
          onSubmitted: (text) {
            if (text.length > 0) {
              setState(() {
                _search = text;
              });
            }
          },
          onClosed: () {
            setState(() {
              _search = '';
            });
          },
          appBarBuilder: (context) {
            return Toolbar();
          },
        ),
        body: Center(
            child:
                _isLogged ? tarefas() : new Text("Seja bem-vindo ao ToDoList ")),
        floatingActionButton: !_isLogged ? null : FloatingActionButton(
          onPressed: () {
            Tarefa tarefa = Tarefa(
                id: null, data: DateTime.now(), nome: '', descricao: '', done: false);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => TarefaPage(tarefa)));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget tarefas() {

    Future<List<Tarefa>> tarefaFutureList = _findAllTarefas();
    if (_search.trim().length > 0) {
      tarefaFutureList = _searchTarefas(_search);
    }

    return Column(
      children: <Widget>[
        Expanded(
            child: FutureBuilder<List<Tarefa>>(
          future: tarefaFutureList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Tarefa>? data = snapshot.data;
              return _tarefasListView(data);
            } else if (snapshot.hasError) {
              print('erro ao recuperar tarefas: ' + snapshot.error.toString());
              return Text("Não existem tarefas cadastradas.");
            }
            return CircularProgressIndicator();
          },
        ))
      ],
    );
  }

  Future<List<Tarefa>> _findAllTarefas() async {
    Preferencias? preferencias = await _preferenciasService.get();

    DateTimeRange periodo = TipoFiltro.TODOS.getPeriodo();
    bool done = false;
    if (preferencias != null) {
      TipoFiltro? tipoFiltro = TipoFiltro.findById(preferencias.tipoFiltro);
      periodo = tipoFiltro.getPeriodo();

      done = preferencias.done;
    }

    DateTime inicio = periodo.start;
    DateTime fim = periodo.end;

    // print('inicio: $inicio');
    // print('fim: $fim');

    List<Tarefa> tarefaList = await _service.findAll(inicio, fim);

    tarefaList = tarefaList.where((tarefa) => tarefa.done == done).toList();

    return tarefaList;
  }

  ListView _tarefasListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index]);
        });
  }

  ListTile _tile(Tarefa tarefa) {
    final DateFormat formatter = DateFormat('EEE, dd/MM/yyyy', 'pt_Br');
    String dataTarefa = formatter.format(tarefa.data);

    return ListTile(
      title: Text(tarefa.nome,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(dataTarefa),
      leading: Icon(
        Icons.event_available,
        color: Colors.blue[500],
      ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => TarefaPage(tarefa)));
      },
    );
  }

  Future<List<Tarefa>> _searchTarefas(String search) async {
    List<Tarefa> tarefaList = await _service.find(search);

    return tarefaList;
  }
}
