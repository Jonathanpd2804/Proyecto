import 'package:david_perez/exports.dart';


class Service {
  final String key;
  final String title;
  final String description;

  Service({required this.key, required this.title, required this.description});
}

class ServicesList extends StatefulWidget {
  const ServicesList({super.key});

  @override
  ServicesListState createState() => ServicesListState();
}

class ServicesListState extends State<ServicesList> {
  List<Service> _services = [];
  final currentUser = FirebaseAuth.instance.currentUser; // Usuario actual
  late UserIsAdmin userIsAdmin;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    getServices();
  }

  Future<void> getServices() async {
    final dbRef = FirebaseFirestore.instance.collection('servicios');
    final snapshot = await dbRef.get();

    List<Service> services = [];
    for (var doc in snapshot.docs) {
      Service service = Service(
        key: doc.id,
        title: doc['Título'],
        description: doc['Descripción'],
      );
      services.add(service);
    }

    setState(() {
      _services = services;
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
              "Lista de Servicios",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          if (isAdmin)
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ServiceForm(),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(myColor),
                ),
                child: const Text("Añadir Servicio")),
          Expanded(
              child: ListView.builder(
                  itemCount: _services.length,
                  itemBuilder: (context, index) {
                    return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Center(
                            child: Text(_services[index].title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(_services[index].description),
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
