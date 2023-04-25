import '../exports.dart';

class ListWorkers extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final user;
  const ListWorkers({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          showBackArrow: true,
        ),
        endDrawer: CustomDrawer(),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Center(
                child: Text(
                  "Lista Trabajadores",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('usuarios')
                    .where("Email", isNotEqualTo: user.email)
                    .where("Trabajador", isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                        child:
                            Text('Error al cargar la lista de trabajadores'));
                  }

                  final workers = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: workers.length,
                    itemBuilder: (context, index) {
                      final worker = workers[index];
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Card(
                          color: Colors.grey[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 4.0,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  title: Text(worker['Nombre']),
                                ),
                                const Divider(
                                  height: 10,
                                  color: Colors.white,
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(12.0),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PerfilPage(
                                          userEmail: worker["Email"],
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text("Ver perfil"),
                                  ),
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(12.0),
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CalendarWorker(
                                                workerUid: worker.id,
                                              )),
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text("Ver calendario"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }
}