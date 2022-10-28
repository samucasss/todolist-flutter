import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:todolist_flutter/models/preferencias.dart';
import 'package:http/http.dart' as http;
import 'package:todolist_flutter/services/auth_service.dart';

class PreferenciasService {

  AuthService get _authService => GetIt.instance<AuthService>();

  Future<Preferencias?> get() async {
    String token = _authService.getToken();

    final response =
    await http.get(Uri.parse('http://localhost:3001/preferencia'),
        headers: <String, String>{
          'Authorization': "Bearer $token",
        });

    if (response.statusCode == 200) {
      if (response.body != 'null') {
        Map<String, dynamic> json = jsonDecode(response.body);
        return Preferencias.fromJson(json);
      }

      return null;

    } else {
      int code = response.statusCode;
      throw Exception('Erro ao recuperar preferencias: $code');
    }
  }

  Future<Preferencias> save(Preferencias preferencias) async {
    String token = _authService.getToken();

    final response =
      await http.post(Uri.parse('http://localhost:3001/preferencias'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer $token",
          },
          body: jsonEncode(preferencias.toJson()));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Preferencias.fromJson(json);
    } else {
      int code = response.statusCode;
      throw Exception('Erro ao salvar preferencias: $code');
    }
  }

  Future<bool> delete() async {
    String token = _authService.getToken();

    final response =
    await http.delete(Uri.parse('http://localhost:3001/preferencia'),
        headers: <String, String>{
          'Authorization': "Bearer $token",
        });

    if (response.statusCode == 200) {
      return true;

    } else {
      int code = response.statusCode;
      throw Exception('Erro ao remover preferencias: $code');
    }
  }

}