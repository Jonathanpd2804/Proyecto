import '../exports.dart';

class UserRegister {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController nameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final TextEditingController codigoTrabajador;
  final BuildContext context;
  final bool esTrabajador;

  UserRegister({
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.nameController,
    required this.lastNameController,
    required this.phoneController,
    required this.codigoTrabajador,
    required this.context,
    required this.esTrabajador,
  });

  bool esJefe = false;
  bool esMedidor = false;


  Future<bool> isCodeValid(String code) async {
    // Inicializar Firebase
    await Firebase.initializeApp();

    // Obtener una referencia a la colección "códigos"
    CollectionReference codesRef =
        FirebaseFirestore.instance.collection('códigos');

    // Consultar la colección para ver si el código existe
    QuerySnapshot querySnapshot =
        await codesRef.where('Código', isEqualTo: code).get();

    bool esValido = querySnapshot.docs.isNotEmpty;

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      esJefe = data['Jefe'] ?? false;
      esMedidor = data['Medidor'] ?? false;
    }

    // Si la consulta devuelve documentos, entonces el código existe
    return querySnapshot.docs.isNotEmpty;
  }

  Future signUp() async {
    if (nameController.text == "" || lastNameController.text == "") {
      wrongMessage('No puede haber campos vacíos');
      return;
    }
    if (!passwordConfirmed()) {
      wrongMessage('Contraseñas no iguales');
      return;
    }

    if (!isPasswordStrongEnough()) {
      wrongMessage('La contraseña debe tener al menos 6 carácteres');
      return;
    }

    if (!isPhoneNumberValid()) {
      wrongMessage('Número de telefono invalido');
      return;
    }

    if (!isEmailValid()) {
      wrongMessage('Correo electrónico inválido');
      return;
    }

    try {
      bool emailStatus =
          await checkEmailInUse(); // <-- Verificar si el correo está en uso
      if (emailStatus == true) {
        wrongMessage(
            'El correo electrónico ya está en uso'); // <-- Mostrar mensaje de error si el correo está en uso
        return;
      }
    } catch (e) {
      wrongMessage(e.toString());
      return;
    }

    if (esTrabajador && !await isCodeValid(codigoTrabajador.text.trim())) {
      wrongMessage('Código incorrecto: ${codigoTrabajador.text.trim()}');
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Añadir datos de usuario
      addUserDetails(
          nameController.text.trim(),
          lastNameController.text.trim(),
          int.parse(phoneController.text.trim()),
          emailController.text.trim(),
          esTrabajador,
          esJefe,
          esMedidor);

      // ignore: usebuildcontextsynchronously
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        wrongMessage(
            'El correo electrónico ya está en uso'); // <-- Mensaje personalizado para correo en uso
      } else {
        wrongMessage("Error: ${e.toString()}"); // <-- Mostrar otros errores
      }
    } catch (e) {
      wrongMessage(
          "Error: ${e.toString()}"); // <-- Mostrar errores no relacionados con FirebaseAuth
    }
  }

  bool isEmailValid() {
    String email = emailController.text.trim();
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  bool isPhoneNumberValid() {
    String phone = phoneController.text.trim();
    RegExp phoneRegExp = RegExp(r'^[67]\d{8}$');
    return phoneRegExp.hasMatch(phone);
  }

  bool isPasswordStrongEnough() {
    return passwordController.text.trim().length >= 6;
  }

  Future<bool> checkEmailInUse() async {
    try {
      await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(emailController.text.trim());
      return false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return true;
      } else {
        throw Exception('Error verificando correo electrónico');
      }
    }
  }

  Future<bool?> emailAlreadyInUse() async {
    try {
      await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(emailController.text.trim());
      return false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return true;
      } else {
        return null;
      }
    }
  }

  void wrongMessage(message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: myColor,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Future addUserDetails(String name, String lastname, int phone, String email,
      bool esTrabajador, bool esJefe, bool esMedidor) async {
    await FirebaseFirestore.instance.collection('usuarios').add({
      'Nombre': name,
      'Apellidos': lastname,
      'Telefono': phone,
      'Email': email,
      'Trabajador': esTrabajador,
      if (esTrabajador) 'Jefe': esJefe,
      if (esTrabajador) 'Medidor': esMedidor,
      if (esMedidor) 'Turno': "No asignado",
    });
  }

  bool passwordConfirmed() {
    if (passwordController.text.trim() ==
        confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }
}
