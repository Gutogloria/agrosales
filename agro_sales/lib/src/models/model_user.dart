class ModelUser {
  final String userUid;
  final String name;
  final String email;
  final String password;
  final String number;
  final String cpf;
  final String endereco;
  final bool isSeller;

  ModelUser({
    required this.userUid,
    required this.name,
    required this.email,
    required this.password,
    required this.number,
    required this.cpf,
    required this.endereco,
    required this.isSeller,
  });

  Map<String, dynamic> toMap() {
    return {
      'userUid': userUid,
      'name': name,
      'email': email,
      'password': password,
      'number': number,
      'cpf': cpf,
      'endereco': endereco,
      'isSeller': isSeller,
    };
  }

  factory ModelUser.fromJson(Map<String, dynamic> json) {
    return ModelUser(
      userUid: json['userUid'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      number: json['number'],
      cpf: json['cpf'],
      endereco: json['endereco'],
      isSeller: json['isSeller'],
    );
  }
}
