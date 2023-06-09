import 'package:david_perez/exports.dart';


class Facility {
  final String key;
  final String title;
  final String description;

  Facility(
      {required this.key, required this.title, required this.description});
}

class FacilitiesList extends StatefulWidget {
  const FacilitiesList({super.key});

  @override
  FacilitiesListState createState() => FacilitiesListState();
}

class FacilitiesListState extends State<FacilitiesList> {
  List<Facility> _facilities = [];
  final currentUser = FirebaseAuth.instance.currentUser; // Usuario actual
  late UserIsAdmin userIsAdmin;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    obtenerServicios();
  }

  Future<void> obtenerServicios() async {
    final dbRef = FirebaseFirestore.instance.collection('instalaciones');
    final snapshot = await dbRef.get();

    List<Facility> facilities = [];
    for (var doc in snapshot.docs) {
      Facility facility = Facility(
        key: doc.id,
        title: doc['Título'],
        description: doc['Descripción'],
      );
      facilities.add(facility);
    }

    setState(() {
      _facilities = facilities;
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
              "Lista de Instalaciones",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          if (isAdmin)
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FacilitieForm(),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(myColor),
                ),
                child: const Text("Añadir Instalación")),
          Expanded(
            child: ListView.builder(
                itemCount: _facilities.length,
                itemBuilder: (context, index) {
                  return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                          title: Center(
                            child: Text(_facilities[index].title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(_facilities[index].description),
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
                          }));
                }),
          ),
        ]));
  }
}
