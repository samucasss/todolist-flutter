class Preferencias {
  final String? id;
  String tipoFiltro;
  bool done;

  Preferencias({required this.id, required this.tipoFiltro, required this.done});

  factory Preferencias.fromJson(Map<String, dynamic> json) {
    return Preferencias(
        id: json['id'],
        tipoFiltro: json['tipoFiltro'],
        done: json['done']
    );
  }

  Map toJson() => {
    'id': id,
    'tipoFiltro': tipoFiltro,
    'done': done,
  };


}