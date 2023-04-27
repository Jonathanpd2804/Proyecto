import '../exports.dart';

class UserIsAdmin {
  final User? user;
  bool isAdmin = false;

  UserIsAdmin(this.user);

  Future<void> getUser() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('Email', isEqualTo: user?.email)
        .get();

    final data = querySnapshot.docs.first.data();
    isAdmin = data['Administrador'] ?? false; // actualiza el valor de isBoss
  }
}

