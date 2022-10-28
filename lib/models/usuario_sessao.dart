class UsuarioSessao {

  String id;
  String nome;
  String email;
  String token;

  UsuarioSessao(this.id, this.nome, this.email, this.token);

  factory UsuarioSessao.fromJson(Map<String, dynamic> json) {
    return UsuarioSessao(json['id'], json['nome'], json['email'], json['token']);
  }

  Map toJson() => {
    'id': id,
    'nome': nome,
    'email': email,
    'token': token,
  };

}