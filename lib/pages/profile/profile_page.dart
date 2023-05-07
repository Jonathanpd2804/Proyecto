
import '../../exports.dart';

// ignore: must_be_immutable
class PerfilPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final userEmail;

  const PerfilPage({
    Key? key,
    this.userEmail,
  }) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  //Correo del usuario a ver
  final UserDeleteService userDeleteService = UserDeleteService();
  // Instancia de la clase UserDeleteService
  final currentUser = FirebaseAuth.instance.currentUser;
  List<String> docIDs = [];

  String documentID = "";

  late UserDocumentID userDocumentID;

  @override
  void initState() {
    super.initState();
// Inicialización de la instancia de UserDocumentID y obtención del documentID
    if (currentUser != null) {
      userDocumentID = UserDocumentID(widget.userEmail);
      userDocumentID.getUserDocumentID().then((_) {
        setState(() {
          documentID = userDocumentID.documentID;
        });
      });
    }
  }

  Stream<QuerySnapshot> getDocsStream() {
    return FirebaseFirestore.instance
        .collection('usuarios')
        .where('Email', isEqualTo: widget.userEmail)
        .snapshots();
  }

  void confirmDeletion(BuildContext context, String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
              '¿Estás seguro de que deseas eliminar? Se borraran todos sus datos'),
          content: const Text('Esta acción no se puede deshacer.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Cerrar el diálogo sin hacer nada
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Eliminar todas las tareas del usuario
                FirebaseFirestore.instance
                    .collection('tareas')
                    .where('Trabajador', isEqualTo: documentId)
                    .get()
                    .then((querySnapshot) {
                  final batch = FirebaseFirestore.instance.batch();
                  for (var doc in querySnapshot.docs) {
                    batch.delete(doc.reference);
                  }
                  return batch.commit();
                }).then((_) {
                  // Eliminar el usuario de Firebase Store
                  return FirebaseFirestore.instance
                      .collection('usuarios')
                      .doc(documentId)
                      .delete();
                }).then((_) {
                  userDeleteService.deleteUserByEmail(widget
                      .userEmail); // Llama al método deleteUserByEmail de UserDeleteService
                }).then((_) {
                  // Regresar a la página de autenticación
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthPage()),
                  );
                });
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBackArrow: true,
      ),
      endDrawer: CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 5),
              child: Center(
                child: SizedBox(
                  width: 300, // Establecer el ancho del Card
                  height: 250, // Establecer la altura del Card
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          15), // Establecer el radio de curvatura
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(
                            15), // Establecer el mismo radio de curvatura que el Card
                      ),
                      child: StreamBuilder(
                        stream: getDocsStream(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            List<DocumentSnapshot> docs = snapshot.data!.docs;
                            return ListView.builder(
                              itemCount: docs.length,
                              itemBuilder: (context, index) {
                                String documentId = docs[index].id;
                                Map<String, dynamic> user =
                                    docs[index].data() as Map<String, dynamic>;

                                return Column(
                                  children: [
                                    ListTile(
                                      leading: Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        padding: const EdgeInsets.all(8.0),
                                        child: const Icon(Icons.person),
                                      ),
                                      title:
                                          GetUserEmail(documentId: documentId),
                                    ),
                                    ListTile(
                                      title:
                                          GetUserName(documentId: documentId),
                                      trailing:
                                          widget.userEmail == currentUser?.email
                                              ? IconButton(
                                                  icon: const Icon(Icons.edit),
                                                  onPressed: () {
                                                    UserEditor.editUserName(
                                                        context, documentId);
                                                  },
                                                )
                                              : null,
                                    ),
                                    ListTile(
                                      title: GetUserLastName(
                                          documentId: documentId),
                                      trailing:
                                          widget.userEmail == currentUser?.email
                                              ? IconButton(
                                                  icon: const Icon(Icons.edit),
                                                  onPressed: () {
                                                    UserEditor.editUserLastName(
                                                        context, documentId);
                                                  },
                                                )
                                              : null,
                                    ),
                                    ListTile(
                                      title: GetUserPhone(
                                          documentId: documentId),
                                      trailing:
                                          widget.userEmail == currentUser?.email
                                              ? IconButton(
                                                  icon: const Icon(Icons.edit),
                                                  onPressed: () {
                                                    UserEditor.editUserPhone(
                                                        context, documentId);
                                                  },
                                                )
                                              : null,
                                    ),
                                    if (user["Medidor"] == true)
                                      ListTile(
                                        title: GetUserTurn(
                                            workerDocumentId: documentId),
                                        trailing: widget.userEmail !=
                                                currentUser?.email
                                            ? IconButton(
                                                icon: const Icon(Icons.edit),
                                                onPressed: () {
                                                  UserEditor.editUserTurn(
                                                      context, documentId);
                                                },
                                              )
                                            : null,
                                      ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red)),
                                      onPressed: () {
                                        confirmDeletion(context, documentId);
                                      },
                                      child: const Text('Eliminar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text('Error al cargar los datos'));
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 15),
              child: Text(
                  widget.userEmail == currentUser?.email
                      ? "Mis Citas:"
                      : "Sus Citas:",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25)),
            ),
            Expanded(
                child: QuotesListView(
              clientEmail: widget.userEmail,
              clientUid: documentID,
            )),
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 15),
              child: Text(
                  widget.userEmail == currentUser?.email
                      ? "Mis Reservas:"
                      : "Sus reservas:",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25)),
            ),
            Expanded(
                child: BookingsListView(
              clientEmail: widget.userEmail,
            )),
          ],
        ),
      ),
    );
  }
}
