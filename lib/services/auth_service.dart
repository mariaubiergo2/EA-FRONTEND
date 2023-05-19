//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // SignIn with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Empezamos el logIn con Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtenemos los detalles de la request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Obtenemos las credenciales del AuthProvider
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Hacemos SignIn con los credenciales que nos da google
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      // Print user info
      print('User ID: ${user?.uid}');
      print('Display Name: ${user?.displayName}');
      print('Email: ${user?.email}');
      print('Photo URL: ${user?.photoURL}');

      return userCredential;
    } catch (e) {
      print('Sign-in with Google failed: $e');
      return null;
    }
  }
}

// class AuthService {
// //SignIn con Google
//   signInWithGoogle() async {
//     //Begin intercative sign in process
//     final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
//     //Obtain auth details from request
//     final GoogleSignInAuthentication gAuth = await gUser!.authentication;
//     //Create new credentials for user
//     final credential = GoogleAuthProvider.credential(
//       accessToken: gAuth.accessToken,
//       idToken: gAuth.idToken,
//     );
//     //Finally sign in
//     print(FirebaseAuth.instance.signInWithCredential(credential));
//     return await FirebaseAuth.instance.signInWithCredential(credential);
//   }
  
// }
