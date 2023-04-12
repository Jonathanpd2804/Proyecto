import '../exports.dart';

class UserIsWorker {
  final User? user;
  bool isWorker = false;

  UserIsWorker(this.user);

  Future<void> getUser() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('Email', isEqualTo: user?.email)
        .get();

    final data = querySnapshot.docs.first.data();
    isWorker = data['Trabajador'] ?? false; // actualiza el valor de isWorker
  }
}

