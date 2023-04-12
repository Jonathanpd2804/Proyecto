import '../exports.dart';

// ignore: must_be_immutable
class PerfilPage extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final userEmail;
  final currentUser = FirebaseAuth.instance.currentUser;
  PerfilPage({super.key, this.userEmail});

  List<String> docIDs = [];

  Stream<QuerySnapshot> getDocsStream() {
    return FirebaseFirestore.instance
        .collection('usuarios')
        .where('Email', isEqualTo: userEmail)
        .snapshots();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void deleteUserByEmail(String email) async {
    User? user = _auth.currentUser;

    if (user != null && user.email == email) {
      // Si el usuario actual es el que se quiere eliminar, se cierra su sesión primero
      await user.delete();
    } else {
      // Si el usuario a eliminar no está logueado actualmente, se utiliza el método deleteUser() directamente
      await _auth
          .signInWithEmailAndPassword(
              email: email,
              password:
                  'contraseña') // Se requiere contraseña para confirmar la identidad del usuario
          .then((credential) => credential.user!.delete());
    }
  }

  void confirmarEliminacion(BuildContext context, String documentId) {
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
                  querySnapshot.docs.forEach((doc) {
                    batch.delete(doc.reference);
                  });
                  return batch.commit();
                }).then((_) {
                  // Eliminar el usuario de Firebase Store
                  return FirebaseFirestore.instance
                      .collection('usuarios')
                      .doc(documentId)
                      .delete();
                }).then((_) {
                  deleteUserByEmail(userEmail);
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

  void editUserName(BuildContext context, String documentId) {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar nombre'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nuevo nombre',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar', style: TextStyle(color: myColor)),
            ),
            TextButton(
              onPressed: () async {
                String newName = nameController.text;
                if (newName.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('usuarios')
                      .doc(documentId)
                      .update({'Nombre': newName});
                }
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text('Guardar', style: TextStyle(color: myColor)),
            ),
          ],
        );
      },
    );
  }

  void editUserLastName(BuildContext context, String documentId) {
    TextEditingController lastNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar apellidos'),
          content: TextField(
            controller: lastNameController,
            decoration: const InputDecoration(
              labelText: 'Nuevos apellidos',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar', style: TextStyle(color: myColor)),
            ),
            TextButton(
              onPressed: () async {
                String newLastName = lastNameController.text;
                if (newLastName.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('usuarios')
                      .doc(documentId)
                      .update({'Apellidos': newLastName});
                }
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text('Guardar', style: TextStyle(color: myColor)),
            ),
          ],
        );
      },
    );
  }

  void editUserTelefono(BuildContext context, String documentId) {
    TextEditingController telefonoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar telefono'),
          content: TextField(
            controller: telefonoController,
            decoration: const InputDecoration(
              labelText: 'Nuevo telefono',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar', style: TextStyle(color: myColor)),
            ),
            TextButton(
              onPressed: () async {
                String newTelefono = telefonoController.text;
                if (newTelefono.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('usuarios')
                      .doc(documentId)
                      .update({'Telefono': newTelefono});
                }
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text('Guardar', style: TextStyle(color: myColor)),
            ),
          ],
        );
      },
    );
  }

  void editUserTurno(BuildContext context, String documentId) {
    String? newTurno;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar turno'),
          content: DropdownButton<String>(
            value: newTurno,
            hint: const Text('Selecciona un turno'),
            items: <String>['Mañana', 'Tarde'].map<DropdownMenuItem<String>>(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList(),
            onChanged: (String? newValue) {
              newTurno = newValue;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar', style: TextStyle(color: myColor)),
            ),
            TextButton(
              onPressed: () async {
                if (newTurno != null) {
                  await FirebaseFirestore.instance
                      .collection('usuarios')
                      .doc(documentId)
                      .update({'Turno': newTurno});
                }
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text('Guardar', style: TextStyle(color: myColor)),
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
                                      trailing: userEmail == currentUser?.email
                                          ? IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () {
                                                editUserName(
                                                    context, documentId);
                                              },
                                            )
                                          : null,
                                    ),
                                    ListTile(
                                      title: GetUserLastName(
                                          documentId: documentId),
                                      trailing: userEmail == currentUser?.email
                                          ? IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () {
                                                editUserLastName(
                                                    context, documentId);
                                              },
                                            )
                                          : null,
                                    ),
                                    ListTile(
                                      title: GetUserTelefono(
                                          documentId: documentId),
                                      trailing: userEmail == currentUser?.email
                                          ? IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () {
                                                editUserTelefono(
                                                    context, documentId);
                                              },
                                            )
                                          : null,
                                    ),
                                    if (user["Medidor"] == true ||
                                        user["Medidor"] != null)
                                      ListTile(
                                        title: GetUserTurno(
                                            documentId: documentId),
                                        trailing: userEmail !=
                                                currentUser?.email
                                            ? IconButton(
                                                icon: const Icon(Icons.edit),
                                                onPressed: () {
                                                  editUserTurno(
                                                      context, documentId);
                                                },
                                              )
                                            : null,
                                      ),
                                    if (currentUser?.email == userEmail)
                                      ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.red)),
                                        onPressed: () {
                                          confirmarEliminacion(
                                              context, documentId);
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
          ],
        ),
      ),
    );
  }
}
