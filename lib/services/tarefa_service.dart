import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:todolist_flutter/models/tarefa.dart';
import 'package:todolist_flutter/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TarefaService {
  AuthService get _authService => GetIt.instance<AuthService>();

  Future<List<Tarefa>> findAll(DateTime inicio, DateTime fim) async {
    String token = _authService.getToken();

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String inicioParam = formatter.format(inicio);
    final String fimParam = formatter.format(fim);

    String url =
        'http://localhost:3001/tarefas?inicio=$inicioParam&fim=$fimParam';

    final response = await http.get(Uri.parse(url), headers: <String, String>{
      'Authorization': "Bearer $token",
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);

      List<Tarefa> tarefaList =
          jsonResponse.map((obj) => Tarefa.fromJson(obj)).toList();
      tarefaList.sort((a, b) => a.data.compareTo(b.data));

      return tarefaList;
    } else {
      int code = response.statusCode;
      throw Exception('Erro ao recuperar tarefas $code');
    }
  }

  Future<Tarefa> save(Tarefa tarefa) async {
    String token = _authService.getToken();

    final response = await http.post(Uri.parse('http://localhost:3001/tarefas'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(tarefa.toJson()));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Tarefa.fromJson(json);
    } else {
      int code = response.statusCode;
      throw Exception('Erro ao salvar tarefa: ' + response.body);
    }
  }

  Future<bool> delete(Tarefa tarefa) async {
    String token = _authService.getToken();

    String id = tarefa.id!;

    final response = await http.delete(
        Uri.parse('http://localhost:3001/tarefas/$id'),
        headers: <String, String>{
          'Authorization': "Bearer $token",
        });

    if (response.statusCode == 200) {
      return true;
    } else {
      int code = response.statusCode;
      throw Exception('Erro ao remover tarefa: $code');
    }
  }

  Future<List<Tarefa>> find(String search) async {
    String token = _authService.getToken();

    String url = 'http://localhost:3001/tarefas/find?text=$search';

    final response = await http.get(Uri.parse(url), headers: <String, String>{
      'Authorization': "Bearer $token",
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);

      List<Tarefa> tarefaList =
          jsonResponse.map((obj) => Tarefa.fromJson(obj)).toList();
      tarefaList.sort((a, b) => a.data.compareTo(b.data));

      return tarefaList;
    } else {
      int code = response.statusCode;
      throw Exception('Erro ao recuperar tarefas $code');
    }
  }
}
