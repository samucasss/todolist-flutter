class Tarefa {

  final String? id;
  DateTime data;
  String nome;
  String descricao;
  bool done;

  Tarefa({required this.id, required this.data, required this.nome, required this.descricao,
    required this.done});

  factory Tarefa.fromJson(Map<String, dynamic> json) {
    return Tarefa(
        id: json['id'],
        data: DateTime.parse(json['data']),
        nome: json['nome'],
        descricao: json['descricao'],
        done: json['done']
    );
  }

  Map toJson() => {
    'id': id,
    'data': data.toString(),
    'nome': nome,
    'descricao': descricao,
    'done': done,
  };

}