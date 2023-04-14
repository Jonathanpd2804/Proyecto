import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
