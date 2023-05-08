import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'navbar.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});
  final String apiUrl = 'http://127.0.0.1:3002/user/count';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: const Text('EETAC -  GO'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            final String? token = prefs.getString("token");
            print('El token es $token');
            // Aqui hago la llamada a la API
            final response = await http.get(Uri.parse(apiUrl), headers: {
              'Authorization': 'Bearer: $token',
            });

            // A ver que nos dice
            //print(response.body);
          },
          child: Text('Call API'),
        ),
      ),
    );
  }
}
