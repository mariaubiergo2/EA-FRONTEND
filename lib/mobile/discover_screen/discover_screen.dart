// ignore_for_file: use_build_context_synchronously

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../models/user.dart';
import '../../widget/profile_screen/card_user_widget.dart';

void main() async {
  await dotenv.load();
}

class MakeFriendsScreen extends StatefulWidget {
  const MakeFriendsScreen({super.key});

  @override
  State<MakeFriendsScreen> createState() => _MakeFriendsScreen();
}

class _MakeFriendsScreen extends State<MakeFriendsScreen> {
  List<User> friendsList = [];
  List<User> notFriendsList = [];
  String? _idUser = "";

  @override
  void initState() {
    super.initState();
    getUserInfo();
    getFriends();
    getNotFriends();
  }

  Future<void> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = prefs.getString('idUser');
    });
  }

  Future getFriends() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    String path = 'http://${dotenv.env['API_URL']}/user/friends/$_idUser';
    try {
      var response = await Dio().get(
        path,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      var users = response.data as List;

      setState(() {
        friendsList = users.map((user) => User.fromJson2(user)).toList();
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   elevation: 0,
      //   behavior: SnackBarBehavior.floating,
      //   backgroundColor: Colors.transparent,
      //   content: AwesomeSnackbarContent(
      //     title: 'Unable! $e',
      //     message: 'Try again later.',
      //     contentType: ContentType.failure,
      //   ),
      // ));
    }
  }

  Future getNotFriends() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    String path =
        'http://${dotenv.env['API_URL']}/user/friends/unfollowing/$_idUser';
    try {
      var response = await Dio().get(
        path,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      var users = response.data as List;

      setState(() {
        notFriendsList = users.map((user) => User.fromJson2(user)).toList();
      });
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   elevation: 0,
      //   behavior: SnackBarBehavior.floating,
      //   backgroundColor: Colors.transparent,
      //   content: AwesomeSnackbarContent(
      //     title: 'Unable! $e',
      //     message: 'Try again later.',
      //     contentType: ContentType.failure,
      //   ),
      // ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color.fromARGB(255, 25, 25, 25),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 35, 25, 35),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 22.5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 242, 242, 242),
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 17.5),
                            child: TextFormField(
                              cursorColor:
                                  const Color.fromARGB(255, 222, 66, 66),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 25, 25, 25)),
                              decoration: const InputDecoration(
                                hintText: 'Search for a user...',
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 146, 146, 146)),
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 12.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(100.0),
                      color: const Color.fromARGB(255, 222, 66, 66),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(100.0),
                        onTap: () {
                          // Acción del botón
                        },
                        child: const SizedBox(
                          width:
                              49.5, // Establece un tamaño fijo para el Container
                          height:
                              49.5, // Establece un tamaño fijo para el Container
                          child: Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 23.0, // Cambia el tamaño del icono
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            try {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: MyUserCard(
                                  idUserSession: _idUser!,
                                  idCardUser: notFriendsList[index].idUser,
                                  attr1: notFriendsList[index].name,
                                  attr2: notFriendsList[index].username,
                                  attr3: notFriendsList[index].level.toString(),
                                  following: false,
                                ),
                              );
                            } catch (e) {
                              return const SizedBox();
                            }
                          },
                          childCount: notFriendsList.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
