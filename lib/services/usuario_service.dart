import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:todolist_flutter/models/usuario.dart';
import 'package:todolist_flutter/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UsuarioService {
  AuthService get _authService => GetIt.instance<AuthService>();

  Future<Usuario> save(Usuario usuario) async {
    String token = _authService.getToken();

    final response =
        await http.post(Uri.parse('http://localhost:3001/usuario'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': "Bearer $token",
            },
            body: jsonEncode(usuario.toJson()));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Usuario.fromJson(json);

    } else {
      int code = response.statusCode;
      throw Exception('Erro ao salvar usuario: $code');
    }
  }

  Future<bool> delete() async {
    String token = _authService.getToken();

    final response = await http.delete(
        Uri.parse('http://localhost:3001/usuario'),
        headers: <String, String>{
          'Authorization': "Bearer $token",
        });

    if (response.statusCode == 200) {
      return true;

    } else {
      int code = response.statusCode;
      throw Exception('Erro ao remover usuario: $code');
    }
  }
}
