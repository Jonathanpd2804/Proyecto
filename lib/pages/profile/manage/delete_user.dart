import '../../../exports.dart';

class UserDeleteService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> deleteUserByEmail(String email) async {
    // ignore: non_constant_identifier_names
    final CurrentUser = _auth.currentUser;

    if (CurrentUser != null && CurrentUser?.email == email) {
      // Si el usuario actual es el que se quiere eliminar, se cierra su sesión primero
      await CurrentUser.delete();
    } else {
      // Si el usuario a eliminar no está logueado actualmente, se utiliza el método deleteUser() directamente
      await _auth
          .signInWithEmailAndPassword(
              email: email,
              password:
                  'contraseña') // Se requiere contraseña para confirmar la identidad del usuario
          .then((credential) => credential.user!.delete());
    }
  }

  
}
