import 'package:david_perez/exports.dart';
import 'package:david_perez/pages/maintenances/add_maintenance.dart';

class Maintenance {
  final String key;
  final String title;
  final String description;

  Maintenance(
      {required this.key, required this.title, required this.description});
}

class MaintenanceList extends StatefulWidget {
  const MaintenanceList({super.key});

  @override
  MaintenanceListState createState() => MaintenanceListState();
}

class MaintenanceListState extends State<MaintenanceList> {
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
    for (var doc in snapshot.docs) {
      Maintenance maintenance = Maintenance(
        key: doc.id,
        title: doc['Título'],
        description: doc['Descripción'],
      );
      maintenances.add(maintenance);
    }

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
        body: Column(children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Lista de Mantenimientos",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          if (isAdmin)
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MaintenanceForm(),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(myColor),
                ),
                child: const Text("Añadir mantenimiento")),
          Expanded(
              child: ListView.builder(
                  itemCount: _maintenances.length,
                  itemBuilder: (context, index) {
                    return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Center(
                            child: Text(_maintenances[index].title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(_maintenances[index].description),
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
                        ));
                  }))
        ]));
  }
}
