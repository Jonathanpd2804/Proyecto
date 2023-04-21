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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // pop the loading circle
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
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
