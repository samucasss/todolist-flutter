import 'dart:convert';

import 'package:todolist_flutter/models/tecnologia.dart';
import 'package:http/http.dart' as http;

class TecnologiaService {

  Future<List<Tecnologia>> findAll() async {
    final response =
        await http.get(Uri.parse('http://localhost:3001/tecnologias'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            });

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((obj) => Tecnologia.fromJson(obj)).toList();

    } else {
      int code = response.statusCode;
      throw Exception('Erro ao recuperar tecnologias $code');
    }

  }
}