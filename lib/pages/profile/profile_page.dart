import '../../exports.dart';

// ignore: must_be_immutable
class PerfilPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final userEmail; //Email de el usuario a ver

  const PerfilPage({Key? key, this.userEmail}) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final UserDeleteService userDeleteService = UserDeleteService();
  // Instancia de la clase UserDeleteService
  final currentUser = FirebaseAuth.instance.currentUser;
  List<String> docIDs = [];

  String userID = "";

  late UserDocumentID userDocumentID;

  @override
  void initState() {
    super.initState();
// Inicialización de la instancia de UserDocumentID y obtención del documentID
    if (currentUser != null) {
      userDocumentID = UserDocumentID(widget.userEmail);
      userDocumentID.getUserDocumentID().then((_) {
        setState(() {
          userID = userDocumentID.documentID;
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
      appBar: CustomAppBar(
        showBackArrow: true,
      ),
      endDrawer: CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100.0, bottom: 20),
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
                                      title: GetUserTelefono(
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
                                        title: GetUserTurno(
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
                                    if (currentUser?.email == widget.userEmail)
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
                      : "Sus Tareas Asignadas:",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25)),
            ),
            Expanded(
              child: widget.userEmail == currentUser?.email
                  ? CitasListView(
                      clienteEmail: currentUser?.email,
                      clienteUid: userID,
                      userEmail: currentUser?.email,
                    )
                  : TaskListView(
                      workerUid: userID,
                      workerEmail: widget.userEmail,
                      isAssigned: true,
                      edit: false,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
