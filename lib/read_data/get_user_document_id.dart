import '../exports.dart';

class UserDocumentID {
  final String? userEmail;
  String documentID = "";

  UserDocumentID(this.userEmail);

  Future<void> getUserDocumentID() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('Email', isEqualTo: userEmail)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('User not found');
    }

    documentID = querySnapshot.docs.first.id;
  }
}
