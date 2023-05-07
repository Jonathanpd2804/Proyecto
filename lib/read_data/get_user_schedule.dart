import '../exports.dart';


class GetUserTurn extends StatelessWidget {
  final String workerDocumentId; //Id de el trabajador

  const GetUserTurn({super.key, required this.workerDocumentId});


  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('usuarios');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(workerDocumentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text('Turno: ${data['Turno']}');
        }
        return const Text('cargando...');
      },
    );
  }
}
