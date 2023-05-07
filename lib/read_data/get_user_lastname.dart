import '../exports.dart';

class GetUserLastName extends StatelessWidget {
  final String documentId;

  const GetUserLastName({super.key, required this.documentId});

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
          return Text('Apellidos: ${data['Apellidos']}');
        }
        return const Text('cargando...');
      },
    );
  }
}
