import '../exports.dart';

class UserIsBoss {
  final User? user;
  bool isBoss = false;

  UserIsBoss(this.user);

  Future<void> getUser() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('Email', isEqualTo: user?.email)
        .get();

    final data = querySnapshot.docs.first.data();
    isBoss = data['Jefe'] ?? false; // actualiza el valor de isBoss
  }
}
