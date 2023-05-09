import 'dart:convert';

class Token {
  Token({
    required this.value,
  });

  final String value;

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "token": value,
      };
}
