

import '../exports.dart';

// Clase HomePage que extiende StatefulWidget
class HomePage extends StatefulWidget {
  final currentUser = FirebaseAuth.instance.currentUser; // Usuario actual

  // Constructor HomePage
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Instancia de la base de datos de Firestore
  final FirebaseFirestore database = FirebaseFirestore.instance;

  // Función que devuelve un Stream de QuerySnapshot de la colección "jobs"
  Stream<QuerySnapshot> fetchJobsStream() {
    return database.collection('trabajos').snapshots();
  }

  bool isBoss = false;

  late UserIsBoss userIsBoss;
  @override
  void initState() {
    super.initState();
    // Inicialización de la instancia de UserIsBoss y obtención del valor isBoss
    userIsBoss = UserIsBoss(widget.currentUser);
    userIsBoss.getUser().then((_) {
      setState(() {
        isBoss = userIsBoss.isBoss;
      });
    });
  }

  // Método build() que construye la estructura de la página principal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Barra de navegación personalizada
        appBar: CustomAppBar(
          showBackArrow: false,
        ),
        // Cajón lateral personalizado
        endDrawer: CustomDrawer(),
        // Cuerpo de la página principal
        body: SingleChildScrollView(
          child: Column(children: [
            const Padding(
              padding: EdgeInsets.only(top: 40.0, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Fila de Iconos sobre los servicios que se realizan
                  IconsHome(
                    iconURL: 'lib/images/servicios.png',
                    text: 'Servicios',
                  ),
                  IconsHome(
                    iconURL: 'lib/images/mantenimientos.png',
                    text: 'Mantenimientos',
                  ),
                  IconsHome(
                    iconURL: 'lib/images/instalaciones.png',
                    text: 'Instalaciones',
                  )
                ],
              ),
            ),
            JobsCardsRow(),
            if (isBoss)
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 250),
                child: Row(
                  children: [
                    const Text(
                      "Añadir trabajo",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const JobForm()),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 12.0),
                        child: Icon(Icons.add),
                      ),
                    )
                  ],
                ),
              ),
            // Column(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.only(top: 40.0),
            //       child: SizedBox(
            //         width: 400,
            //         height: 200,
            //         child: ComentariosYPuntuacion(),
            //       ),
            //     ),
            //   ],
            // ),
          ]),
        ));
  }
}
