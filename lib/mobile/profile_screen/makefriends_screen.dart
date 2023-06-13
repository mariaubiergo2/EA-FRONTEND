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
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'You may know...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                try {
                  return MyUserCard(
                    idUserSession: _idUser!,
                    idCardUser: notFriendsList[index].idUser,
                    attr1: notFriendsList[index].name,
                    attr2: notFriendsList[index].username,
                    attr3: notFriendsList[index].level.toString(),
                    following: false,
                  );
                } catch (e) {
                  return SizedBox(); // Return an empty SizedBox if the index is out of range
                }
              },
              childCount: notFriendsList.length,
            ),
          ),
        ),
      ],
    );
  }
}
