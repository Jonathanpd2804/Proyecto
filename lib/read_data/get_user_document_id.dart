import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDocumentID {
  final User user;
  String documentID = "";

  UserDocumentID(this.user);

  Future<void> getUserDocumentID() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('Email', isEqualTo: user.email)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('User not found');
    }

    documentID = querySnapshot.docs.first.id;
  }
}
