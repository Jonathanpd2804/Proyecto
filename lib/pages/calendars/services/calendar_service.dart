import '../../../exports.dart';

class CalendarService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future eliminarCitasAntiguas() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DateTime now = DateTime.now();
    final DateTime startOfToday = DateTime(now.year, now.month, now.day);

    final QuerySnapshot snapshot = await firestore
        .collection('citas')
        .where('Fecha', isLessThan: startOfToday)
        .get();

    for (final doc in snapshot.docs) {
      await firestore.collection('citas').doc(doc.id).delete();
    }
  }

  Future<QuerySnapshot<Object?>> getUserDataFuture() {
    return FirebaseFirestore.instance
        .collection('usuarios')
        .where('Email', isEqualTo: currentUser?.email)
        .get();
  }

  Future<String> getClienteUid() async {
    QuerySnapshot<Object?> userDataQuery = await getUserDataFuture();

    if (userDataQuery.docs.isNotEmpty) {
      return userDataQuery.docs.first.id;
    } else {
      // Manejar el caso cuando no se encuentra el documento
      return "";
    }
  }

  Future<QuerySnapshot<Object?>> getWorkerTurn(turn) {
    return FirebaseFirestore.instance
        .collection('usuarios')
        .where('Turno', isEqualTo: turn)
        .get();
  }

  Future<String> getWorkerUid(turn) async {
    QuerySnapshot<Object?> userDataQuery = await getWorkerTurn(turn);

    if (userDataQuery.docs.isNotEmpty) {
      return userDataQuery.docs.first.id;
    } else {
      // Manejar el caso cuando no se encuentra el documento
      return "";
    }
  }
}
