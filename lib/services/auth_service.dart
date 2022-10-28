import 'dart:convert';

import 'package:localstorage/localstorage.dart';
import 'package:todolist_flutter/models/login.dart';
import 'package:todolist_flutter/models/usuario.dart';
import 'package:todolist_flutter/models/usuario_sessao.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static final _KEY_USER = 'USER';

  final _storage = new LocalStorage('todolist');
  UsuarioSessao? _usuarioSessao = null;

  Future<Usuario> register(Usuario usuario) async {

    final response =
      await http.post(Uri.parse('http://localhost:3001/auth/register'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(usuario.toJson()));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Usuario.fromJson(json);

    } else {
      int code = response.statusCode;
      throw Exception('Erro ao registrar usuario: $code');
    }
  }

  Future<bool> autentica(String email, String senha) async {
    String token = await login(email, senha);
    Usuario usuario = await _user(token);
    _storeUser(usuario, token);

    return true;
  }

  Future<String> login(String email, String senha) async {
    Login login = Login(email, senha);

    final response =
        await http.post(Uri.parse('http://localhost:3001/auth/login'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(login.toJson()));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      String token = json['token'];

      return token;
    } else {
      throw Exception('Erro no login');
    }
  }

  Future<Usuario> _user(String token) async {
    final response =
        await http.get(Uri.parse('http://localhost:3001/auth/user'),
            headers: <String, String>{
              'Authorization': "Bearer $token",
            });

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      Map<String, dynamic> user = jsonDecode(jsonEncode(json['user']));
      Usuario usuario = Usuario.fromJson(user);

      return usuario;

    } else {
      throw Exception('Erro no login');
    }
  }

  void _storeUser(Usuario usuario, String token) {
    UsuarioSessao usuarioSessao = UsuarioSessao(usuario.id!, usuario.nome, usuario.email, token);

    String user = jsonEncode(usuarioSessao.toJson());
    _storage.setItem(_KEY_USER, user);

    _usuarioSessao = usuarioSessao;
  }

  bool isLogged() {
    return _usuarioSessao != null;
  }

  UsuarioSessao? getUser() {
    return _usuarioSessao;
  }

  Future<void> readUser() async {
    if (_usuarioSessao != null) return;

    await _storage.ready;
    String? user = _storage.getItem(_KEY_USER);

    if (user != null) {
      Map<String, dynamic> json = jsonDecode(user);
      _usuarioSessao = UsuarioSessao.fromJson(json);
    }
  }

  String getToken() {
    return _usuarioSessao!.token;
  }

  void updateUser(Usuario usuario) {
    _usuarioSessao?.nome = usuario.nome;
    _usuarioSessao?.email = usuario.email;

    String user = jsonEncode(_usuarioSessao?.toJson());
    _storage.setItem(_KEY_USER, user);
  }

  void deleteUser() async {
    await _storage.deleteItem(_KEY_USER);
    _usuarioSessao = null;
  }

  Future<void> logout() async {
    deleteUser();
  }
}
