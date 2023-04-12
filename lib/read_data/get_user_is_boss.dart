import '../exports.dart';

class UserIsBoss {
  final User? user;
  late bool isBoss;

  UserIsBoss(this.user) {
    isBoss = false; // Establecer un valor predeterminado
    getUserPermissions();
  }

  Future<void> getUserPermissions() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('Email', isEqualTo: user?.email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final userData = querySnapshot.docs.first.data();
      if (userData.containsKey('Jefe')) {
        isBoss = userData['Jefe'];
      }
    }
  }
}
