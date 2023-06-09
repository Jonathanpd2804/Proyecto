import '../exports.dart';


class GetUserName extends StatelessWidget {
  final String documentId;

  const GetUserName({super.key, required this.documentId});


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
          return Text('Nombre: ${data['Nombre']}');
        }
        return const Text('cargando...');
      },
    );
  }

  
}
