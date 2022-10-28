class Tecnologia {
  final String id;
  final String nome;
  final String tipo;

  Tecnologia({required this.id, required this.nome, required this.tipo});

  factory Tecnologia.fromJson(Map<String, dynamic> json) {
    return Tecnologia(
      id: json['id'],
      nome: json['nome'],
      tipo: json['tipo']
    );
  }
}