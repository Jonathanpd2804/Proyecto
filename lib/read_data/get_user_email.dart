import '../exports.dart';


class GetUserEmail extends StatelessWidget {
  final String documentId;

  const GetUserEmail({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('usuarios');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          
          return AutoSizeText(
            '${data['Email']}',
            maxLines: 1,
          );
        }
        return const Text('cargando...');
      },
    );
  }
}
