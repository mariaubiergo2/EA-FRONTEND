import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/user.dart';
import '../../widget/card_user_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _idUser = "";
  String? _name = "";
  String? _surname = "";
  String? _username = "";
  String? _token = "";
  String? _followers = "";
  String? _following = "";
  int _level = 0;
  bool _seeFollowing = false;
  bool _seeFollowers = false;
  bool _seeOptions = true;
  List<User> followingList = [];
  List<User> followersList = [];
  // PickedFile? _imageFile;
  // final ImagePicker _picker = ImagePicker();
  // List<CameraDescription>? _cameras;
  // CameraController? _controller;
  // CameraImage? _image;
  CameraDescription? _firstCamera;


  final TextStyle _highlightedText = const TextStyle(
      color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18);

  final TextStyle _normalText = const TextStyle(
      color: Color.fromARGB(255, 242, 242, 242),
      fontWeight: FontWeight.normal,
      fontSize: 18);

  late TextStyle _textStyleFollowers;
  late TextStyle _textStyleFollowing;

  @override
  void initState() {
    super.initState();
    getUserInfo();
    getFriendsInfo();
    getFollowing();
    getFollowers();
    _textStyleFollowers = _normalText;
    _textStyleFollowing = _normalText;
  }

  @override
  void dispose() {
    // _controller!.dispose();
    super.dispose();
  }

  Widget imageProfile(){
    return Stack(
      children: [
        const CircleAvatar(
          radius: 80,
          backgroundImage: AssetImage('images/example.png'),
        ),
        Positioned(
          bottom: 5.0,
          right: 5.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder)=>bottomSheet()),
              );
            },
            child: const Icon(
              Icons.camera_enhance,
              color: Colors.amber,
              size: 25.0,
            ),
          ),          
        )
    ],
    );    
  }

  Widget bottomSheet(){
    return Container(
      height:100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(children: [
        const Text(
          "Choose a profile photo",
          style: TextStyle(
            fontSize: 18),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          //   Expanded(
          //   child: AspectRatio(
          //     aspectRatio: _controller!.value.aspectRatio,
          //     child: CameraPreview(_controller!),
          //   ),
          // ),
          // IconButton(onPressed: takePicture
          // , icon: Icon(Icons.camera_alt)),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/takepicture_screen');
              },
              child: 
              //   AspectRatio(
              //   aspectRatio: _controller.value.aspectRatio,
              //   child: CameraPreview(_controller),
            
                const Icon(
                  Icons.camera_alt,
                  color: Color.fromARGB(255, 7, 119, 255),
                  size: 25.0,
                ),
            ),
            const SizedBox(
              width: 20,
            ),
            InkWell(
            onTap: () {},
            child: const Icon(
              Icons.image,
              color: Color.fromARGB(255, 7, 119, 255),
              size: 25.0,
              semanticLabel: "Gallery",
            ),
            ),
          ],
        )
      ]),
    );
  }

// void takePhoto(ImageSource source, ImagePicker picker) async{
//     final pickedFile = await picker.getImage(
//       source: source,
//     );
//     setState(() {
//       _imageFile = pickedFile!;
//     });
//   }


  Future<void> takePicture() async {
    // if (!_controller!.value.isInitialized) {
    //   return;
    // }

    // try {
    //   await _controller!.takePicture().then((XFile file) {
    //     // Do something with the captured image file
    //     // e.g., save it to local storage or display it in the app
    //   });
    // } catch (e) {
    //   print(e);
    // }
  }

  Future clearInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token');
      _idUser = prefs.getString('idUser');
      _name = prefs.getString('name');
      _surname = prefs.getString('surname');
      _username = prefs.getString('username');
      try {
        _level = prefs.getInt('level')!;
      } catch (e) {
        print(e);
        _level = 0;
      }
    });
  }

  Future getFriendsInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var followersCount = await Dio().get(
          'http://${dotenv.env['API_URL']}/user/followers/count/${_idUser!}');

      setState(() {
        _followers = followersCount.toString();
      });

      var followingCount = await Dio().get(
          'http://${dotenv.env['API_URL']}/user/following/count/${_idUser!}');

      setState(() {
        _following = followingCount.toString();
      });
    } catch (e) {
      print('Error in the counting of friends: $e');
    }
  }

  Future getFollowing() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    String path = 'http://${dotenv.env['API_URL']}/user/following/$_idUser';
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
        followingList = users.map((user) => User.fromJson2(user)).toList();
      });
    } catch (e) {
    }
  }

  Future getFollowers() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    String path = 'http://${dotenv.env['API_URL']}/user/followers/$_idUser';
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
        followersList = users.map((user) => User.fromJson2(user)).toList();
      });
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      body: SafeArea(
          child: Center(
        child: SizedBox(
          width: 1080,
          child:
              Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                  Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  imageProfile(),
                  const SizedBox(height: 30),
                  Text(
                    '$_name $_surname',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 242, 242, 242),
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$_username',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 242, 242, 242),
                        fontSize: 13),
                  ),
                  const SizedBox(height: 30),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Level ' + _level.toString(),
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 242, 242, 242),
                            fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      value: _level.toDouble() / 100,
                      backgroundColor: Colors.white,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Divider(
                    color: Color.fromARGB(255, 52, 52, 52),
                    height: 0.05,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _seeFollowing = !_seeFollowing;
                            if (_seeFollowing) {
                              _seeOptions = false;
                              _seeFollowers = false;
                              _textStyleFollowing = _highlightedText;
                              _textStyleFollowers = _normalText;
                            } else {
                              _seeOptions = true;
                              _textStyleFollowing = _normalText;
                            }
                          });
                        },
                        child: Text(
                          "$_following\nFollowing",
                          textAlign: TextAlign.center,
                          style: _textStyleFollowing,
                        ),
                      ),
                      SizedBox(width: 100),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _seeFollowers = !_seeFollowers;
                            if (_seeFollowers) {
                              _seeOptions = false;
                              _seeFollowing = false;
                              _textStyleFollowers = _highlightedText;
                              _textStyleFollowing = _normalText;
                            } else {
                              _seeOptions = true;
                              _textStyleFollowers = _normalText;
                            }
                          });
                        },
                        child: Text(
                          "$_followers\nFollowers",
                          textAlign: TextAlign.center,
                          style: _textStyleFollowers,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    color: Color.fromARGB(255, 52, 52, 52),
                    height: 0.05,
                  ),
                  const SizedBox(height: 30),
                  // Following scroll page
                  Visibility(
                    visible: _seeFollowing, // not visible if set false
                    child: Container(
                      height: 250,
                      child: ListView.builder(
                        itemCount: followingList.length,
                        itemBuilder: (BuildContext context, int index) {
                          try {
                            return MyUserCard(
                              idUserSession: _idUser!,
                              idCardUser: followingList[index].idUser,
                              attr1:
                                  '${followingList[index].name} ${followingList[index].surname}',
                              attr2: followingList[index].username,
                              attr3: followingList[index].level.toString(),
                              following: true,
                            );
                          } catch (e) {
                            return SizedBox();
                          }
                        },
                      ),
                    ),
                  ),
                  // Followers scroll view
                  Visibility(
                    visible: _seeFollowers, // not visible if set false
                    child: Container(
                      height: 250,
                      child: ListView.builder(
                        itemCount: followersList.length,
                        itemBuilder: (BuildContext context, int index) {
                          try {
                            return MyUserCard(
                              idUserSession: _idUser!,
                              idCardUser: followersList[index].idUser,
                              attr1:
                                  '${followersList[index].name} ${followersList[index].surname}',
                              attr2: followersList[index].username,
                              attr3: followersList[index].level.toString(),
                              following: true,
                            );
                          } catch (e) {
                            return SizedBox(); // Return an empty SizedBox if the index is out of range
                          }
                        },
                      ),
                    ),
                  ),

                  Visibility(
                    visible: _seeOptions,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 222, 66, 66),
                                  ),
                                ),
                                const SizedBox(width: 25),
                                const Text(
                                  "Edit accotunt",
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 242, 242, 242),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                              ]),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 222, 66, 66),
                                  ),
                                ),
                                const SizedBox(width: 25),
                                const Text(
                                  "Information",
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 242, 242, 242),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                              ]),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 222, 66, 66),
                                  ),
                                ),
                                const SizedBox(width: 25),
                                const Text(
                                  "Delete account",
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 242, 242, 242),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                              ]),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 222, 66, 66),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                TextButton(
                                    onPressed: () {
                                      clearInfo();
                                      Navigator.pushNamed(
                                          context, '/login_screen');
                                    },
                                    child: const Text(
                                      "LogOut",
                                      style: TextStyle(
                                        color: Color.fromARGB(
                                            255, 242, 242, 242),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                    ))
                              ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      )));
  }
}
