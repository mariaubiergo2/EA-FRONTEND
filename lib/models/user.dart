import 'dart:convert';

class User {
  User(
      {required this.idUser,
      required this.name,
      required this.surname,
      required this.username,
      this.imageURL,
      this.email,
      this.password,
      this.experience,
      this.level,
      this.active});

  final String idUser;
  final String name;
  final String surname;
  final String username;
  final String? imageURL;
  final String? email;
  final String? password;
  final int? experience;
  final int? level;
  final bool? active;
  factory User.fromJson(Map<String, dynamic> json) => User(
        idUser: json["idUser"],
        name: json["name"],
        surname: json["surname"],
        username: json["username"],
        imageURL: json["imageURL"],
        level: json["level"],
        experience: json["experience"],
        active: json["active"],
        // email: json["email"],
        // password: json["password"],
      );

  factory User.fromJson2(Map<String, dynamic> json) => User(
        idUser: json["_id"],
        name: json["name"],
        surname: json["surname"],
        username: json["username"],
        imageURL: json["imageURL"],
        level: json["level"],
        experience: json["experience"],
        active: json["active"],

        // email: json["email"],
        // password: json["password"],
      );

  get foto => null;

  Map<String, dynamic> toJson() => {
        "_id": idUser,
        "name": name,
        "surname": surname,
        "experience": experience,
        // "username": username,
        // "email": email,
        // "password": password,
      };
}
