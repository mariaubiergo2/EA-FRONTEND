
import 'dart:convert';

List<Challenge> subjectFromJson(String str) => List<Challenge>.from(json.decode(str).map((x) => Challenge.fromJson(x)));

String subjectToJson(List<Challenge> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Challenge {
    Challenge({
        required this.id,
        required this.name,
        required this.descr,
        required this.exp,
        required this.users,
    });

    final String id;
    final String name;
    final String descr;
    final int exp;
    final List<User> users;

    factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
        id: json["_id"],
        name: json["name"],
        descr: json["descr"],
        exp: json["exp"],
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "descr": descr,
        "exp": exp,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
    };
}

class User {
    User({
        required this.id,
        required this.name,
        required this.surname,
        required this.email,
        required this.password,
    });

    final String id;
    final String name;
    final String surname;
    final String email;
    final String password;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        surname: json["surname"],
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "surname": surname,
        "email": email,
        "password": password,
    };
}