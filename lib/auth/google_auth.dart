import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../pages/home_page.dart';

class GoogleAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

      final googleCredential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);

      final UserCredential userCredential = await _auth.signInWithCredential(googleCredential);
      final User? user = userCredential.user;

      if (user != null) {
        final User? existingUser = (await _auth.fetchSignInMethodsForEmail(user.email!)).isNotEmpty
            ? _auth.currentUser
            : null;

          // Navega a HomePage después de iniciar sesión correctamente
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );

        if (existingUser == null) {
          // Vincula la cuenta de Google con la cuenta de Email/Password
          final emailCredential = EmailAuthProvider.credential(
            email: user.email!,
            password: 'yourPassword', // La contraseña de la cuenta de Email/Password existente
          );
                    await user.linkWithCredential(emailCredential);
        } else {
          // Si ya existe una cuenta vinculada, actualiza la información del usuario
          await user.updateDisplayName(existingUser.displayName);
          await user.updatePhotoURL(existingUser.photoURL);
        }
      }

      return userCredential;
    } catch (e) {
      print('Error al iniciar sesión con Google: $e');
      return null; // Devuelve null si se produce un error
    }
  }  
}
