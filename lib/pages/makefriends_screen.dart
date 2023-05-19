import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../models/user.dart';
import '../widget/card_widget.dart';



class MakeFriendsScreen extends StatefulWidget {
  const MakeFriendsScreen({super.key});

  @override
  State<MakeFriendsScreen> createState() => _MakeFriendsScreen();
}

class _MakeFriendsScreen extends State<MakeFriendsScreen> {
  User? user;
  List<User> userList = <User>[];
  String? _idUser = "";
  String? _name = "";
  String? _surname = "";
  String? _username = "";
  String? _token = "";
  final panelController = PanelController();

  @override
  void initState() {
    super.initState();
    getUserInfo();
    getUsers();
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

  Future getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    //3("/get/all", checkJwt, getAllUsers);
    String path = 'http://127.0.0.1:3002/user/get/all';
    try {
      var response = await Dio().get(path,
              options: Options(headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $token",
              }));

          var usuarios = response.data as List;

          for (var sub in usuarios) {
            userList.add(User.fromJson2(sub));
          }
          setState(() {
            userList = userList;
          });
    } catch (e, stackTrace){
      print('Error: $e');
      print('Stack Trace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Unable! $e',
            message: 'Try again later.',
            contentType: ContentType.failure,
          ),
        ));
    }
  }

 


@override
Widget build(BuildContext context) {
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
                return MyCard(
                  name: userList[index].name,
                  descr: userList[index].surname,
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
}