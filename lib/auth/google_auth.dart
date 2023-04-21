import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

import '../exports.dart';

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

      final signInMethods = await _auth.fetchSignInMethodsForEmail(gUser.email!);

      if (signInMethods.contains('password')) {
  // Muestra un cuadro de diálogo para solicitar la contraseña al usuario
  final password = await _showPasswordDialog(context);
  if (password != null) {
    try {
      // Intenta iniciar sesión con el correo electrónico y la contraseña proporcionados
      UserCredential emailUserCredential =
          await _auth.signInWithEmailAndPassword(email: gUser.email!, password: password);
          
      // Verifica si la cuenta de Google ya está vinculada a la cuenta de correo electrónico/contraseña
      if (!signInMethods.contains('google.com')) {
        // Vincula la cuenta de Google con la cuenta de correo electrónico/contraseña existente
        final UserCredential userCredential =
            await emailUserCredential.user!.linkWithCredential(googleCredential);
      }
      
      final User? user = emailUserCredential.user;

      if (user != null) {
        // Navega a HomePage después de iniciar sesión correctamente
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }

      return emailUserCredential;
    } on FirebaseAuthException catch (e) {
      // Muestra un mensaje de error si la contraseña es incorrecta
      if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: Contraseña incorrecta'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.message}'),
          ),
        );
      }
    }
  }
  return null;

      } else if (signInMethods.contains('google.com')) {
        // Si el correo electrónico ya está registrado con Google, permite el inicio de sesión con Google
        final UserCredential userCredential = await _auth.signInWithCredential(googleCredential);
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
        // Si el correo electrónico no está registrado, muestra un mensaje de error
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

  Future<String?> _showPasswordDialog(BuildContext context) async {
    String? password;
    return showDialog<String>(
      context: context,
            barrierDismissible: false, // El usuario debe tocar el botón
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ingrese su contraseña'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(password);
              },
            ),
          ],
        );
      },
    );
  }
}

