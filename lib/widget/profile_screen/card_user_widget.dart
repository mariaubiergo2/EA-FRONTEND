// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await dotenv.load();
}

class MyUserCard extends StatefulWidget {
  final String idUserSession;
  final String idCardUser;
  final String attr1;
  final String attr2;
  final String attr3;
  final bool following;

  const MyUserCard(
      {Key? key,
      required this.idUserSession, //the id in shared preferences
      required this.idCardUser, //the id of the user that appears in the card
      required this.attr1, //photo url of the user
      required this.attr2, //username
      required this.attr3, //exp or level of the user
      required this.following //if true it means that the user is following the one it has started session
      })
      : super(key: key);

  @override
  State<MyUserCard> createState() => _MyUserCard();
}

class _MyUserCard extends State<MyUserCard> {
  String buttonText = "";

  @override
  void initState() {
    super.initState();
    setFollowingState();
    //getFriends();
  }

  Future setFollowingState() async {
    if (widget.following) {
      buttonText = "Following";
    } else {
      buttonText = "Follow";
    }
  }

  Future followOrUnfollow() async {
    if (widget.following) {
      buttonText = "Following";
    } else {
      startFollowing();
    }
    setFollowingState();
  }

  Future startFollowing() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    String path =
        'http://${dotenv.env['API_URL']}/user/follow/add/${widget.idUserSession}/${widget.idCardUser}';
    try {
      var response = await Dio().post(path,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          }));

      // var registros = response.data as List;

      // for (var sub in registros) {
      //   userList.add(User.fromJson2(sub));
      // }
      setState(() {
        // following = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Unable to follow!',
          message: 'Try again later.',
          contentType: ContentType.failure,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 242, 242, 242),
              borderRadius: BorderRadius.circular(16),
            ),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(22.5, 8, 8, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 13.5),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color.fromARGB(
                        255, 242, 242, 242), // Cambia el color de fondo aquí
                    child: ClipOval(
                      child: Image.asset(
                        'images/default.png', //attr1 in the future, when the profile has an image
                        fit: BoxFit.fill,
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 22.5, 0),
                  child: Container(
                    width: 0.75,
                    height: 47.5,
                    color: const Color.fromARGB(255, 222, 66, 66),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.attr2,
                      style: const TextStyle(
                        fontStyle: FontStyle.normal,
                        color: Color.fromARGB(255, 25, 25, 25),
                        fontSize: 22.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Level ${widget.attr3}',
                      style: const TextStyle(
                        fontStyle: FontStyle.normal,
                        color: Color.fromARGB(255, 25, 25, 25),
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
                // Spacer(),
                // Expanded(
                //   child:
                //   Align(
                //     widthFactor: 2,
                //     alignment: Alignment.centerRight,
                //     child: GestureDetector(
                //       onTap: followOrUnfollow,
                //       child: Container(
                //         height: 30,
                //         width: 110,
                //         padding: const EdgeInsets.all(2),
                //         margin: const EdgeInsets.symmetric(horizontal: 1),
                //         decoration: BoxDecoration(
                //           border: Border.all(
                //             color: const Color.fromARGB(255, 242, 242, 242),
                //             width: 1,
                //           ),
                //           color: Color.fromARGB(255, 222, 66, 66),
                //           borderRadius: BorderRadius.circular(20),
                //         ),
                //         child: Center(
                //           child: Text(
                //             buttonText,
                //             style: const TextStyle(
                //               color: Color.fromARGB(255, 242, 242, 242),
                //               // fontWeight: FontWeight.bold,
                //               fontSize: 14,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
