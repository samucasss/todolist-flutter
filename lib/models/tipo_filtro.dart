import 'package:flutter/material.dart';

enum TipoFiltro {

  TODOS('T', 'Todos'),
  HOJE('H', 'Hoje'),
  AMANHA('A', 'Amanhã'),
  SEMANA('S', 'Semana');

  final String id;
  final String nome;

  const TipoFiltro(this.id, this.nome);

  static TipoFiltro findById(String id) {
    for (TipoFiltro tipoFiltro in values) {
      if (tipoFiltro.id == id) {
        return tipoFiltro;
      }
    }

    return TipoFiltro.TODOS;
  }
}

extension TipoFiltroExtension on TipoFiltro {

  DateTimeRange getPeriodo() {
    DateTime d = DateUtils.dateOnly(DateTime.now());
    return getPeriodoReferencia(d);
  }

  DateTimeRange getPeriodoReferencia(DateTime d) {
    switch (this) {
      case TipoFiltro.TODOS:
        return _filterTodos(d);

      case TipoFiltro.HOJE:
        return _filterHoje(d);

      case TipoFiltro.AMANHA:
        return _filterAmanha(d);

      case TipoFiltro.SEMANA:
        return _filterSemana(d);

      default:
        return _filterTodos(d);
    }
  }

  DateTimeRange _filterTodos(DateTime d) {
    d = DateUtils.dateOnly(d);
    DateTime inicio = d.subtract(Duration(days: 10));
    DateTime fim = d.add(Duration(days: 10));

    return DateTimeRange(start: inicio, end: fim);
  }

  DateTimeRange _filterHoje(DateTime d) {
    d = DateUtils.dateOnly(d);
    DateTime inicio = d;
    DateTime fim = d.add(Duration(days: 1));

    return DateTimeRange(start: inicio, end: fim);
  }

  DateTimeRange _filterAmanha(DateTime d) {
    d = DateUtils.dateOnly(d);
    DateTime inicio = d.add(Duration(days: 1));
    DateTime fim = d.add(Duration(days: 2));

    return DateTimeRange(start: inicio, end: fim);
  }

  DateTimeRange _filterSemana(DateTime d) {
    d = DateUtils.dateOnly(d);

    int daysOfWeek = d.weekday;
    DateTime firstDay = DateTime(d.year, d.month, d.day - daysOfWeek);
    DateTime lastDay = DateUtils.dateOnly(firstDay).add(Duration(days: 7));

    DateTime inicio = firstDay;
    DateTime fim = lastDay;

    return DateTimeRange(start: inicio, end: fim);
  }

}