import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:todolist_flutter/models/tecnologia.dart';
import 'package:todolist_flutter/services/tecnologia_service.dart';

class TecnologiaPage extends StatelessWidget {

  TecnologiaService get _service => GetIt.instance<TecnologiaService>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tecnologias'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Voltar',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
          ],
        ),
        body: Center(
            child: FutureBuilder<List<Tecnologia>>(
              future: _service.findAll(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Tecnologia>? data = snapshot.data;
                  return _tecnologiasListView(data);

                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
            )
        ),
      ),
    );
  }

  ListView _tecnologiasListView(data) {

    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index].nome, data[index].tipo, Icons.work);
        });
  }

  ListTile _tile(String title, String subtitle, IconData icon) => ListTile(
    title: Text(title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    subtitle: Text(subtitle),
    leading: Icon(
      icon,
      color: Colors.blue[500],
    ),
  );
}