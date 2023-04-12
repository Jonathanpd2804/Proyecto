import 'package:david_perez/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/my_textfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
          // ignore: use_build_context_synchronously
          showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('¡Link enviado! Revisa tu email'),
            );
          });
    } on FirebaseAuthException catch (e) {
      
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColor,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Introduce tu email y te enviaremos un link para restablecer tu contraseña',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          // email textfield
          MyTextField(
            controller: _emailController,
            hintText: 'Email',
            obscureText: false,
          ),
          MaterialButton(
            onPressed: passwordReset,
            color: myColor,
            child: const Text('Reset Password'),
          )
        ],
      ),
    );
  }
}
