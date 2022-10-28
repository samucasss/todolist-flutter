import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:todolist_flutter/componentes/botao.dart';
import 'package:todolist_flutter/componentes/message_dialog.dart';
import 'package:todolist_flutter/main.dart';
import 'package:todolist_flutter/models/preferencias.dart';
import 'package:todolist_flutter/models/tipo_filtro.dart';
import 'package:todolist_flutter/services/preferencias_service.dart';

class PreferenciasPage extends StatefulWidget {

  @override
  _PreferenciasState createState() => _PreferenciasState();

}

class _PreferenciasState extends State<PreferenciasPage> {
  PreferenciasService get _service => GetIt.instance<PreferenciasService>();

  late TextEditingController _controllerTipoFiltro = TextEditingController();
  Preferencias? _preferencias = null;

  @override
  void initState() {
    _getPreferencias();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Preferências"),
      ),
      body: SingleChildScrollView(
          child: Card(
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 30, bottom: 0),
                    child: TextField(
                      controller: _controllerTipoFiltro,
                      decoration: InputDecoration(
                        suffixIcon: PopupMenuButton<String>(
                          icon: const Icon(Icons.arrow_drop_down),
                          onSelected: (String value) {
                            setState(() {
                              TipoFiltro? tipoFiltro = TipoFiltro.findById(value);
                              if (tipoFiltro != null) {
                                _preferencias?.tipoFiltro = tipoFiltro.id;
                                _controllerTipoFiltro.text = tipoFiltro.nome;
                              }
                            });
                          },
                          itemBuilder: (BuildContext context) {
                            return TipoFiltro.values
                                .map<PopupMenuItem<String>>((TipoFiltro tipoFiltro) {
                              return new PopupMenuItem(
                                  child: new Text(tipoFiltro.nome), value: tipoFiltro.id);
                            }).toList();
                          },
                        ),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 0),
                    //padding: EdgeInsets.symmetric(horizontal: 15),
                    child: CheckboxListTile(
                      title: const Text('Concluído?'),
                      value: _preferencias != null ? _preferencias?.done : false,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? value) {
                        setState(() {
                          _preferencias?.done = value!; // rebuilds with new value
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
                        if (_preferencias?.id != null)
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 15, bottom: 15),
                            child: Botao('Excluir', _confirmDelete)
                          )
                      ],
                    )),
              ],
            ),
          )),
    );
  }

  void _getPreferencias() async {
    Preferencias? preferencias = await _service.get();

    TipoFiltro? tipoFiltro = TipoFiltro.TODOS;
    if (preferencias != null) {
      tipoFiltro = TipoFiltro.findById(preferencias.tipoFiltro);

      setState(() {
        _preferencias = preferencias; // rebuilds with new value
      });

    } else {
      _preferencias = Preferencias(id: null, tipoFiltro: tipoFiltro!.nome, done: false);
    }

    _controllerTipoFiltro.text = tipoFiltro!.nome;
  }

  void _save() {
    _service.save(_preferencias!).then((value) {
      MessageDialog.showMessageSucesso(context);

      Future.delayed(Duration(seconds: 1), () =>
        Navigator.pushReplacement(
            context!, MaterialPageRoute(builder: (_) => App()))
      );

    }).catchError((e) =>
        MessageDialog.showMessageError(context, "Erro ao salvar preferências"));
  }

  void _confirmDelete() {
    MessageDialog.showConfirmationDialog(
        context!,
        "Tem certeza que deseja excluir seu registro do sistema?",
        _delete);
  }

  void _delete() {
    _service.delete().then((value) {
      MessageDialog.showMessageSucesso(context);

      Future.delayed(Duration(seconds: 1), () =>
          Navigator.pushReplacement(
              context!, MaterialPageRoute(builder: (_) => App()))
      );

    });
  }

}
