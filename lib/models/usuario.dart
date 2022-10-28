class Usuario {

  final String? id;
  final String nome;
  final String email;
  final String senha;

  const Usuario({
    required this.id,
    required this.nome,
    required this.email,
    this.senha = ''
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      email: json['email']
    );
  }

  Map toJson() => {
    'id': id,
    'nome': nome,
    'email': email,
    'senha': senha,
  };

}