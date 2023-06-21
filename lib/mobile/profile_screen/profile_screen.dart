// ignore_for_file: library_private_types_in_public_api
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../models/user.dart';
import '../../models/user.dart' as user_ea;
import '../../widget/profile_screen/card_user_widget.dart';
import 'dart:io';
import 'package:flutter/services.dart';

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
  String? _deleteUsername = "";
  // ignore: unused_field
  String? _token = "";
  String? _followers = "";
  String? _following = "";
  int _level = 0;
  bool _seeFollowing = false;
  bool _seeFollowers = false;
  bool _seeOptions = true;
  List<user_ea.User> followingList = [];
  List<user_ea.User> followersList = [];
  FirebaseAuth auth = FirebaseAuth.instance;

  final TextStyle _highlightedText = const TextStyle(
      color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18);

  // ignore: prefer_const_constructors
  final TextStyle _normalText = TextStyle(
      // ignore: prefer_const_constructors
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

  Future clearInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Widget imageProfile() {
    return Stack(
      children: [
        const CircleAvatar(
          radius: 55,
          backgroundImage: AssetImage('images/default.png'),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
              child: const Padding(
                padding: EdgeInsets.all(9.0),
                child: Icon(
                  Icons.camera_enhance_rounded,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 175,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(0, 35, 0, 0),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 25, 25, 25),
      ),
      child: Column(
        children: [
          const Text(
            "Choose a profile photo",
            style: TextStyle(
                fontSize: 18, color: Color.fromARGB(255, 242, 242, 242)),
          ),
          const SizedBox(
            height: 35,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 222, 66, 66),
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () {
                    pickImageFromGallery(ImageSource.camera);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 22.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 35,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 222, 66, 66),
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () {
                    pickImageFromGallery(ImageSource.gallery);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.image,
                      color: Colors.white,
                      size: 22.0,
                      semanticLabel: "Gallery",
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> pickImageFromGallery(ImageSource source) async {
    try {
      final imagePicker = ImagePicker();
      final pickedImage = await imagePicker.pickImage(source: source);
      if (pickedImage != null) {
        // Do something with the picked image
        final imageTemporary = File(pickedImage.path);
        print(imageTemporary);
      }
    } on PlatformException catch (e) {
      print('Failed to pick the image: $e');
    }
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
        followingList =
            users.map((user) => user_ea.User.fromJson2(user)).toList();
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
        followersList =
            users.map((user) => user_ea.User.fromJson2(user)).toList();
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

  deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    String path = 'http://${dotenv.env['API_URL']}/user/disable/$_idUser';
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

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Account successfully deleted',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color.fromARGB(255, 222, 66, 66),
            showCloseIcon: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
            content: const Text(
              'Unable to delete your account. Try again later',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromARGB(255, 222, 66, 66),
          showCloseIcon: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
          content: const Text(
            'Unable to delete your account. Try again later',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 1080,
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          imageProfile(),
                          const SizedBox(height: 25),
                          Text(
                            '$_name $_surname',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.color,
                                fontWeight: FontWeight.w600,
                                fontSize: 25),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '$_username',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.color,
                                fontSize: 20),
                          ),
                          const SizedBox(height: 10),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment
                                    .centerLeft, // Alinea el contenido a la izquierda
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 17.0),
                                  child: Text(
                                    '${AppLocalizations.of(context)!.level} $_level',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.color,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      5.0), // Establece los bordes redondeados
                                  child: LinearProgressIndicator(
                                    minHeight: 10,
                                    value: _level.toDouble() / 100,
                                    backgroundColor: Colors.white,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              const Divider(
                                color: Color.fromARGB(255, 52, 52, 52),
                                height: 0.05,
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
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
                                      _textStyleFollowers = TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.color,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18);
                                    } else {
                                      _seeOptions = true;
                                      _textStyleFollowing = TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.color,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18);
                                    }
                                  });
                                },
                                child: Text(
                                  "$_following\n${AppLocalizations.of(context)!.following}",
                                  // "$_following\nFollowing",
                                  textAlign: TextAlign.center,
                                  style: _textStyleFollowing,
                                ),
                              ),
                              const SizedBox(width: 100),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _seeFollowers = !_seeFollowers;
                                    if (_seeFollowers) {
                                      _seeOptions = false;
                                      _seeFollowing = false;
                                      _textStyleFollowers = _highlightedText;
                                      _textStyleFollowing = TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.color,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18);
                                    } else {
                                      _seeOptions = true;
                                      _textStyleFollowers = TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.color,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18);
                                    }
                                  });
                                },
                                child: Text(
                                  "$_followers\n${AppLocalizations.of(context)!.followers}",
                                  // "$_followers\nFollowers",
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
                          const SizedBox(height: 32.5),
                          // Following scroll page
                          Visibility(
                            visible: _seeFollowing, // not visible if set false
                            child: SizedBox(
                              height: 300,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: followingList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  try {
                                    return MyUserCard(
                                      idUserSession: _idUser!,
                                      idCardUser: followingList[index].idUser,
                                      attr1:
                                          '${followingList[index].name} ${followingList[index].surname}',
                                      attr2: followingList[index].username,
                                      attr3:
                                          followingList[index].level.toString(),
                                      following: true,
                                    );
                                  } catch (e) {
                                    return const SizedBox();
                                  }
                                },
                              ),
                            ),
                          ),
                          // Followers scroll view
                          Visibility(
                            visible: _seeFollowers, // not visible if set false
                            child: SizedBox(
                              height: 300,
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
                                      attr3:
                                          followersList[index].level.toString(),
                                      following: true,
                                    );
                                  } catch (e) {
                                    return const SizedBox(); // Return an empty SizedBox if the index is out of range
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
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      // Acción cuando se presione el contenedor
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: const Icon(
                                            Icons.menu_book_rounded,
                                            color: Color.fromARGB(
                                                255, 222, 66, 66),
                                            size: 22,
                                          ),
                                        ),
                                        const SizedBox(width: 25),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .information,
                                          // "Edit account",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                ?.color,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 25),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      // Acción cuando se presione el contenedor
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: const Icon(
                                            Icons.edit_rounded,
                                            color: Color.fromARGB(
                                                255, 222, 66, 66),
                                            size: 22,
                                          ),
                                        ),
                                        const SizedBox(width: 25),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .edit_account,
                                          // "Edit account",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                ?.color,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 28.5),
                                const Divider(
                                  color: Color.fromARGB(255, 52, 52, 52),
                                  height: 0.05,
                                ),
                                const SizedBox(height: 28.5),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                            title:
                                                const Text('Eliminar cuenta'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                    '¿Estás seguro de que quieres eliminar tu cuenta? \n\nAl eliminar tu cuenta, esta quedará inaccesible y no podrás utilizarla. \n\nPara reactivarla, será necesario contactar con nuestro equipo de soporte. \n\nPor favor, considera esta opción con cuidado antes de confirmar la eliminación. \n\n\nEscribe tu nombre de usuario para confirmar:',
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1
                                                            ?.color)),
                                                const SizedBox(height: 45),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 2.0),
                                                  child: TextField(
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _deleteUsername = value;
                                                      });
                                                    },
                                                    cursorColor:
                                                        const Color.fromARGB(
                                                            255, 222, 66, 66),
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 25, 25, 25),
                                                    ),
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .headline1
                                                              ?.color,
                                                      hintText: _username,
                                                      hintStyle:
                                                          const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 146, 146, 146),
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    100.0),
                                                        borderSide:
                                                            BorderSide.none,
                                                      ),
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .fromLTRB(
                                                              18.5, 14, 0, 0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                style: ButtonStyle(
                                                  foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                    const Color.fromARGB(
                                                        255, 222, 66, 66),
                                                  ),
                                                ),
                                                child: const Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  if (_username ==
                                                      _deleteUsername) {
                                                    deleteUser();
                                                    auth.signOut();
                                                    GoogleSignIn().signOut();
                                                    clearInfo();
                                                    Navigator
                                                        .pushReplacementNamed(
                                                            context,
                                                            '/login_screen');
                                                  } else {
                                                    Navigator.of(context).pop();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        backgroundColor:
                                                            Colors.amber,
                                                        showCloseIcon: true,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        margin: const EdgeInsets
                                                                .fromLTRB(
                                                            20, 0, 20, 22.5),
                                                        content: const Text(
                                                          'Nombre de usuario incorrecto',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        closeIconColor:
                                                            Colors.black,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        duration:
                                                            const Duration(
                                                                seconds: 3),
                                                      ),
                                                    );
                                                  }
                                                },
                                                style: ButtonStyle(
                                                  foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                    const Color.fromARGB(
                                                        255, 222, 66, 66),
                                                  ),
                                                ),
                                                child: const Text('Confirmar'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color.fromARGB(
                                                255, 222, 66, 66),
                                          ),
                                          child: const Icon(
                                            Icons.delete_forever_rounded,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                        ),
                                        const SizedBox(width: 25),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .delete_account,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                ?.color,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 25),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      // Acción cuando se presione el contenedor
                                      auth.signOut();
                                      GoogleSignIn().signOut();
                                      clearInfo();
                                      Navigator.pushReplacementNamed(
                                          context, '/login_screen');
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color.fromARGB(
                                                255, 222, 66, 66),
                                          ),
                                          child: const Icon(
                                            Icons.logout_rounded,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Text(
                                          AppLocalizations.of(context)!.log_out,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                ?.color,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 33.5),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
