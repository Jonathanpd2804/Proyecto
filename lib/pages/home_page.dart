import 'package:david_perez/widgets/comentarios.dart';

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
    return database.collection('jobs').snapshots();
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
            // Encabezado de la página
            SizedBox(
              width: 300,
              child: Image.asset(
                'lib/images/banner.png',
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              // Lista horizontal de trabajos
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: SizedBox(
                        height: 260,
                        child: StreamBuilder(
                          // Stream de QuerySnapshot de la colección "jobs"
                          stream: fetchJobsStream(),
                          // Constructor de la lista horizontal de trabajos
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            // Si el estado de conexión es de espera, muestra un indicador de progreso
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            // Si hay un error al cargar los trabajos, muestra un mensaje de error
                            if (snapshot.hasError) {
                              return const Center(
                                  child: Text('Error al cargar los trabajos'));
                            }

                            // Lista de trabajos
                            List<DocumentSnapshot> jobs = snapshot.data!.docs;
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: jobs.length,
                              // Constructor de cada tarjeta de imagen de trabajo
                              itemBuilder: (BuildContext context, int index) {
                                final job =
                                    jobs[index].data() as Map<String, dynamic>;
                                return SizedBox(
                                    width: 150,
                                    child: CardImageWidget(job: job));
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
            const Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 40.0, right: 150),
                  child: Text(
                    "Opiniones",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: SizedBox(
                    width: 400,
                    height: 200,
                    child: ComentariosYPuntuacion(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: CircleIconsWidget(),
                ),
              ],
            ),
          ]),
        ));
  }
}
