import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:todolist_flutter/componentes/botao.dart';
import 'package:todolist_flutter/componentes/message_dialog.dart';
import 'package:todolist_flutter/main.dart';
import 'package:todolist_flutter/models/tarefa.dart';
import 'package:todolist_flutter/services/tarefa_service.dart';

class TarefaPage extends StatefulWidget {

  final Tarefa _tarefa;

  TarefaPage(this._tarefa);

  @override
  _TarefaState createState() => _TarefaState(_tarefa);

}

class _TarefaState extends State<TarefaPage> {

  TarefaService get _service => GetIt.instance<TarefaService>();
  final Tarefa _tarefa;

  late TextEditingController _controllerNome = TextEditingController();
  late TextEditingController _controllerDescricao = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  _TarefaState(this._tarefa);

  @override
  void initState() {
    if (_tarefa.id != null) {
      setState(() {
        _selectedDate = _tarefa.data;
        _controllerNome.text = _tarefa.nome;
        _controllerDescricao.text = _tarefa.descricao;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101));
      if (picked != null && picked != _selectedDate) {
        setState(() {
          _selectedDate = picked;
        });
      }
    }

    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    String dataSelecionada = formatter.format(_selectedDate);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(_tarefa.id != null ? "Editar Tarefa" : "Nova Tarefa"),
        ),
        body: SingleChildScrollView(
        child: Card(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(dataSelecionada),
                ),
              ],
            )
          ),
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
              controller: _controllerDescricao,
              maxLines: 4,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Descrição',
                  hintText: 'Entre com a descrição'),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: CheckboxListTile(
                title: const Text('Concluído?'),
                value: _tarefa != null ? _tarefa?.done : false,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    _tarefa?.done = value!; // rebuilds with new value
                  });
                },
              )),
          Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Botao('OK', _save),
                  if (_tarefa.id != null)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 15),
                      child: Botao('Excluir', _confirmDelete)
                    )
                ],
              )),
        ],
      ),
    )));

  }

  void _confirmDelete() {
    MessageDialog.showConfirmationDialog(
        context!,
        "Tem certeza que deseja excluir seu registro do sistema?",
        _delete);
  }

  bool _validateFields() {
    String nome = _controllerNome.value.text;

    if (nome.trim().length == 0) {
      MessageDialog.showMessageError(
          context!, "O campo Nome deve ser preenchido");
      return false;
    }

    return true;
  }


  void _save() {
    if (_validateFields()) {
      _tarefa.data = DateUtils.dateOnly(_selectedDate);
      _tarefa.nome = _controllerNome.value.text;
      _tarefa.descricao = _controllerDescricao.value.text;

      _service.save(_tarefa).then((value) {
        MessageDialog.showMessageSucesso(context!);

        Future.delayed(Duration(seconds: 1), () =>
            Navigator.pushReplacement(
                context!, MaterialPageRoute(builder: (_) => App()))
        );

      }).catchError((e) =>
          MessageDialog.showMessageError(context!, "Erro ao salvar tarefa " + e.toString()));
    }
  }

  void _delete() {
    _service.delete(_tarefa).then((value) {
      MessageDialog.showMessageSucesso(context);

      Future.delayed(Duration(seconds: 1), () =>
          Navigator.pushReplacement(
              context!, MaterialPageRoute(builder: (_) => App()))
      );

    });
  }

}