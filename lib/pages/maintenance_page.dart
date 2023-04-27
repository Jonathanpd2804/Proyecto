import 'package:david_perez/exports.dart';

class Maintenance {
  final String key;
  final String titulo;
  final String descripcion;

  Maintenance(
      {required this.key, required this.titulo, required this.descripcion});
}

class MaintenanceList extends StatefulWidget {
  @override
  _MaintenanceListState createState() => _MaintenanceListState();
}

class _MaintenanceListState extends State<MaintenanceList> {
  List<Maintenance> _maintenances = [];
  final currentUser = FirebaseAuth.instance.currentUser; // Usuario actual
  late UserIsAdmin userIsAdmin;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    obtenerMaintenances();
  }

  Future<void> obtenerMaintenances() async {
    final dbRef = FirebaseFirestore.instance.collection('mantenimientos');
    final snapshot = await dbRef.get();

    List<Maintenance> maintenances = [];
    snapshot.docs.forEach((doc) {
      Maintenance maintenance = Maintenance(
        key: doc.id,
        titulo: doc['Título'],
        descripcion: doc['Descripción'],
      );
      maintenances.add(maintenance);
    });

    setState(() {
      _maintenances = maintenances;
      userIsAdmin = UserIsAdmin(currentUser);
      userIsAdmin.getUser().then((_) {
        setState(() {
          isAdmin = userIsAdmin.isAdmin;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showBackArrow: true),
      endDrawer: CustomDrawer(),
      body: ListView.builder(
        itemCount: _maintenances.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Lista de Mantenimientos",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              if (isAdmin)
                ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(myColor),
                    ),
                    child: const Text("Añadir Mantenimiento")),
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Center(
                    child: Text(_maintenances[index].titulo,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(_maintenances[index].descripcion),
                          actions: [
                            TextButton(
                              child: const Text("Cerrar"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
