import '../exports.dart';

class ListaMedidores extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final user;
  const ListaMedidores({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(showBackArrow: true,),
      endDrawer: CustomDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('usuarios')
            .where('Medidor', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
                child: Text('Error al cargar la lista de medidores'));
          }

          final trabajadores = snapshot.data!.docs;

          return ListView.builder(
            itemCount: trabajadores.length,
            itemBuilder: (context, index) {
              final trabajador = trabajadores[index];
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
                          title: Text(trabajador['Nombre']),
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
                                  userEmail: trabajador["Email"],
                                ),
                              ),
                            );
                          },
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(12.0),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CalendarioTrabajador(
                                  trabajadorUid: trabajador.id,
                                ),
                              ),
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
    );
  }
}
