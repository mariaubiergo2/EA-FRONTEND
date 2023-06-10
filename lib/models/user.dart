import 'dart:convert';

class User {
  User({
    required this.idUser,
    required this.name,
    required this.surname,
    required this.username,
    this.email,
    this.password,
    this.exp,
    this.level
  });

  final String idUser;
  final String name;
  final String surname;
  final String username;
  final String? email;
  final String? password;
  final int? exp;
  final int? level;

  factory User.fromJson(Map<String, dynamic> json) => User(
        idUser: json["idUser"],
        name: json["name"],
        surname: json["surname"],
        username: json["username"],
        // exp: json["exp"],
        level: json["level"],
        // email: json["email"],
        // password: json["password"],
      );

  factory User.fromJson2(Map<String, dynamic> json) => User(
        idUser: json["_id"],
        name: json["name"],
        surname: json["surname"],
        username: json["username"],
        level: json["level"],
        // email: json["email"],
        // password: json["password"],
      );

  get foto => null;

  Map<String, dynamic> toJson() => {
        "_id": idUser,
        "name": name,
        "surname": surname,
        "exp": exp,
        // "username": username,
        // "email": email,
        // "password": password,
      };
}
