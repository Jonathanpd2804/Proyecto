import '../exports.dart';

class GetUserTelefono extends StatelessWidget {
  final String documentId;

  const GetUserTelefono({super.key, required this.documentId});


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
          return Text('Telefono: ${data['Telefono']}');
        }
        return const Text('cargando...');
      },
    );
  }
}
