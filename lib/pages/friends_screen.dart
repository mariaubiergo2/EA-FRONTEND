import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../widget/friend_widget.dart';
import 'navbar.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FrindsScreen();
}

class _FrindsScreen extends State<FriendsScreen> {
  User? user;
  List<User> userList = <User>[];
  String? _idUser = "";
  String? _name = "";
  String? _surname = "";
  String? _username = "";
  String? _token = "";

  @override
  void initState() {
    super.initState();
    getUserInfo();
    getFriends();
  }

  Future getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token');
      _idUser = prefs.getString('idUser');
      _name = prefs.getString('name');
      _surname = prefs.getString('surname');
      _username = prefs.getString('username');
    });
  }

  Future getFriends() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    //http://IP_PC:3000/subject/all
    String path = 'http://127.0.0.1:3002/user/friends/' + _idUser!;
    print(path);
    var response = await Dio().get(path,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        }));

    var registros = response.data as List;

    for (var sub in registros) {
      userList.add(User.fromJson2(sub));
    }
    setState(() {
      userList = userList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Center(
            child: Text(
              'Friends',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ),
          SizedBox(height: 36),
          buildChallenges11(context, userList),
        ],
      ),
    );
  }
}

@override
Widget buildChallenges11(BuildContext context, List<User> userList) {
  return SizedBox(
    height:
        MediaQuery.of(context).size.height - 100, // ajustar según sea necesario
    width: MediaQuery.of(context).size.width,
    child: Viewport(
      axisDirection: AxisDirection.down,
      offset: ViewportOffset.zero(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Friends(
                  username: userList[index].username,
                  foto:
                      "https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png",
                  exp: userList[index].exp.toString(),
                );
              },
              childCount: userList.length,
            ),
          ),
        ),
      ],
    ),
  );
}
