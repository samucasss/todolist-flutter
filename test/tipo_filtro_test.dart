import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todolist_flutter/models/tipo_filtro.dart';

void main() {
  test('Filtro todos deve retornar periodo de -10 a 10 dias', () {
    final DateTime referencia = DateTime(2022, 9, 15);
    final DateTime inicio = DateTime(2022, 9, 5);
    final DateTime fim = DateTime(2022, 9, 25);

    final DateTimeRange periodoExpected = DateTimeRange(start: inicio, end: fim);
    final DateTimeRange periodoFiltro = TipoFiltro.TODOS.getPeriodoReferencia(referencia);

    expect(periodoFiltro, periodoExpected);
  });

  test('Filtro hoje deve retornar periodo de hoje', () {
    final DateTime referencia = DateTime(2022, 9, 15);
    final DateTime inicio = DateTime(2022, 9, 15);
    final DateTime fim = DateTime(2022, 9, 16);

    final DateTimeRange periodoExpected = DateTimeRange(start: inicio, end: fim);
    final DateTimeRange periodoFiltro = TipoFiltro.HOJE.getPeriodoReferencia(referencia);

    expect(periodoFiltro, periodoExpected);
  });

  test('Filtro amanha deve retornar periodo de amanha', () {
    final DateTime referencia = DateTime(2022, 9, 15);
    final DateTime inicio = DateTime(2022, 9, 16);
    final DateTime fim = DateTime(2022, 9, 17);

    final DateTimeRange periodoExpected = DateTimeRange(start: inicio, end: fim);
    final DateTimeRange periodoFiltro = TipoFiltro.AMANHA.getPeriodoReferencia(referencia);

    expect(periodoFiltro, periodoExpected);
  });

  test('Filtro semana deve retornar periodo do ultimo domingo ao proximo sabado', () {
    final DateTime referencia = DateTime(2022, 9, 26);
    final DateTime inicio = DateTime(2022, 9, 25);
    final DateTime fim = DateTime(2022, 10, 2);

    final DateTimeRange periodoExpected = DateTimeRange(start: inicio, end: fim);
    final DateTimeRange periodoFiltro = TipoFiltro.SEMANA.getPeriodoReferencia(referencia);

    expect(periodoFiltro, periodoExpected);
  });


}