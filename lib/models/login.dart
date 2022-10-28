class Login {
  String email;
  String senha;

  Login(this.email, this.senha);

  Map toJson() => {
    'email': email,
    'senha': senha,
  };
}