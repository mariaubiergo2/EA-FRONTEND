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
  State<MyUserCard> createState() => _MyUserCardState();
}

class _MyUserCardState extends State<MyUserCard> {
  late String buttonText;
  late bool isFollowing;

  @override
  void initState() {
    super.initState();
    setFollowingState();
  }

  void setFollowingState() {
    isFollowing = widget.following;
    buttonText = isFollowing ? "Following" : "Follow";
  }

  Future<void> followOrUnfollow() async {
    setState(() {
      isFollowing = !isFollowing;
      buttonText = isFollowing ? "Following" : "Follow";
    });

    if (isFollowing) {
      await startFollowing();
    } else {
      await stopFollowing();
    }
  }

  Future<void> startFollowing() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    String path =
        'http://${dotenv.env['API_URL']}/user/follow/add/${widget.idUserSession}/${widget.idCardUser}';
    try {
      var response = await Dio().post(
        path,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      setState(() {
        buttonText = "Following";
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Unable to follow!',
            message: 'Try again later.',
            contentType: ContentType.failure,
          ),
        ),
      );
    }
  }

  Future<void> stopFollowing() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    String path =
        'http://${dotenv.env['API_URL']}/user/follow/delete/${widget.idUserSession}/${widget.idCardUser}';
    try {
      var response = await Dio().post(
        path,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      setState(() {
        buttonText = "Follow";
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Unable to unfollow!',
            message: 'Try again later.',
            contentType: ContentType.failure,
          ),
        ),
      );
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.5, right: 8.5),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color.fromARGB(255, 242, 242, 242),
                    child: ClipOval(
                      child: Image.asset(
                        'images/default.png',
                        fit: BoxFit.fill,
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                  child: Container(
                    width: 0.75,
                    height: 47.5,
                    color: const Color.fromARGB(255, 222, 66, 66),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.attr2.length > 12
                            ? '${widget.attr2.substring(0, 12)}...'
                            : widget.attr2,
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
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: followOrUnfollow,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 222, 66, 66),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: isFollowing
                                ? const Icon(
                                    Icons.check,
                                    color: Color.fromARGB(255, 242, 242, 242),
                                    size: 20,
                                  )
                                : const Icon(
                                    Icons.add,
                                    color: Color.fromARGB(255, 242, 242, 242),
                                    size: 20,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
