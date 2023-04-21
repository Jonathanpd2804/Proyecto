import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../exports.dart';

class GoogleAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      await signOut();
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();
      if (gUser == null) {
        return null; // El usuario canceló el proceso de inicio de sesión
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Comprueba si el usuario existe en la colección de usuarios en Firestore
      final QuerySnapshot userQuery = await _firestore
          .collection('usuarios')
          .where('Email', isEqualTo: gUser.email)
          .get();

      if (userQuery.docs.isNotEmpty) {
        // El usuario existe en Firestore, realiza la autenticación
        final googleCredential = GoogleAuthProvider.credential(
            accessToken: gAuth.accessToken, idToken: gAuth.idToken);

        final UserCredential userCredential =
            await _auth.signInWithCredential(googleCredential);
        final User? user = userCredential.user;

        if (user != null) {
          // Navega a HomePage después de iniciar sesión correctamente
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        }

        return userCredential;
      } else {
        // Si el usuario no existe, muestra un mensaje de error y no realiza la autenticación
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: La cuenta no existe'),
          ),
        );
        return null;
      }
    } catch (e) {
      return null; // Devuelve null si se produce un error
    }
  }
}
