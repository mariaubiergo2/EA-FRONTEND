import 'dart:convert';


class User {
    User({
        required this.idUser,
        required this.name,
        required this.surname,
        required this.username,
        this.email,
        this.password,
    });

    final String idUser;
    final String name;
    final String surname;
    final String username;
    final String? email;
    final String? password;

    factory User.fromJson(Map<String, dynamic> json) => User(
        idUser: json["idUser"],
        name: json["name"],
        surname: json["surname"],
        username: json["username"],
        // email: json["email"],
        // password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "_id": idUser,
        "name": name,
        "surname": surname,
        // "username": username,
        // "email": email,
        // "password": password,
    };
}