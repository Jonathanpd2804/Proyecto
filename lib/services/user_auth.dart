import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../exports.dart';

class UserAuth {
  final TextEditingController emailController; //Email
  final TextEditingController passwordController; //Contraseña
  final BuildContext context;

  UserAuth({
    required this.emailController,
    required this.passwordController,
    required this.context,
  });

  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // sign user in method
  Future<void> signUserIn() async {
    //Mostrar el círculo de carga
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try sign in
    try {
      UserCredential? userCredential;
      if (await _googleSignIn.isSignedIn()) {
        // If user signed in with Google, get the Google credentials and sign in
        final GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
        if (googleUser != null) {
          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          userCredential = await auth.signInWithCredential(credential);
        }
      } else {
        // Otherwise, sign in with email and password
        userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      }

      // pop the loading circle
      Navigator.pop(context);

      if (userCredential != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }

    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      //Email incorrecto
      if (e.code == 'user-not-found') {
        wrongEmailMessage();
      }

      //Contraseña incorrecta
      else if (e.code == 'wrong-password') {
        wrongPasswordMessage();
      }
    }
  }

  //Dialogo de Email incorrecto
  Future<void> wrongEmailMessage() async {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: myColor,
          title: Center(
            child: Text(
              'Incorrect Email',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  //Dialogo de contraseña incorrecta
  Future<void> wrongPasswordMessage() async {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: myColor,
          title: Center(
            child: Text(
              'Incorrect Password',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
