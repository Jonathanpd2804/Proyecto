import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:david_perez/exports.dart';
import 'package:flutter/material.dart';

class Servicio {
  final String key;
  final String titulo;
  final String descripcion;

  Servicio(
      {required this.key, required this.titulo, required this.descripcion});
}

class ServicesList extends StatefulWidget {
  @override
  _ServicesListState createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  List<Servicio> _servicios = [];
  final currentUser = FirebaseAuth.instance.currentUser; // Usuario actual
  late UserIsAdmin userIsAdmin;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    obtenerServicios();
  }

  Future<void> obtenerServicios() async {
    final dbRef = FirebaseFirestore.instance.collection('servicios');
    final snapshot = await dbRef.get();

    List<Servicio> servicios = [];
    snapshot.docs.forEach((doc) {
      Servicio servicio = Servicio(
        key: doc.id,
        titulo: doc['Título'],
        descripcion: doc['Descripción'],
      );
      servicios.add(servicio);
    });

    setState(() {
      _servicios = servicios;
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
        itemCount: _servicios.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Lista de Servicios",
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
                    child: const Text("Añadir Servicio")),
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Center(
                    child: Text(_servicios[index].titulo,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(_servicios[index].descripcion),
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
