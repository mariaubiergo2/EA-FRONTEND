import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../models/user.dart';
import '../widget/credential_button.dart';
import '../widget/friend_widget.dart';
import '../widget/panel_widget.dart';
import 'navbar.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FriendsScreen();
}

class _FriendsScreen extends State<FriendsScreen> {
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
    //getFriends();
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
    String path = 'http://127.0.0.1:3002/user/friends/${_idUser!}';
    try {
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
    } catch (e, stackTrace){
      print('Error: $e');
      print('Stack Trace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Unable feature!',
            message: 'Try again later.',
            contentType: ContentType.failure,
          ),
        ));
    }
  }

 


@override
Widget build(BuildContext context) {
  final windowSize = ui.window.physicalSize;
    //en que porcentage de la pantalla se inicia el panel deslizante
    final panelHeightClosed = windowSize.height * 0.07;
    //hasta que porcentage de la pantalla lega el panel
    final panelHeightOpen = windowSize.height * 0.8;
    return Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          title: const Text('EETAC -  GO'),
        ),
        body: Stack(alignment: Alignment.topCenter, children: <Widget>[
          SlidingUpPanel(
            controller: panelController,
            maxHeight: panelHeightOpen,
            minHeight: panelHeightClosed,
            parallaxEnabled: true,
            parallaxOffset: .5,
            panelBuilder: (controller) => PanelWidget(
              controller: controller,
              panelController: panelController,),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            body: Stack(alignment: Alignment.topCenter, children: <Widget>[
               ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: userList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Friends(
                    username: userList[index].username,
                    foto: "https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png",
                    exp: userList[index].exp.toString(),
                  );
                },
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/makefriends_screen');
                },
                child: const Text(
                  "Makefriends",
                  style: TextStyle(
                      color: Color.fromARGB(255, 222, 66, 66),
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ),
            ],),
          ),
        ],
    ),
        // body: Stack(alignment: Alignment.topCenter, children: <Widget>[
        //    SizedBox(
        //     height:
        //         MediaQuery.of(context).size.height - 100, // ajustar según sea necesario
        //     width: MediaQuery.of(context).size.width,
        //     child: Viewport(
        //       axisDirection: AxisDirection.down,
        //       offset: ViewportOffset.zero(),
        //       slivers: [
        //         SliverPadding(
        //           padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //           sliver: SliverList(
        //             delegate: SliverChildBuilderDelegate(
        //               (BuildContext context, int index) {
        //                 return Friends(
        //                   username: userList[index].username,
        //                   foto:
        //                       "https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png",
        //                   exp: userList[index].exp.toString(),
        //                 );
        //               },
        //               childCount: userList.length,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   )],)
        );
  }
}