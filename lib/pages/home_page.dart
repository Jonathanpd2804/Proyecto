// Importación del archivo de exportación
import '../exports.dart';

// Clase HomePage que extiende StatefulWidget
class HomePage extends StatefulWidget {
  // Constructor HomePage
  const HomePage({Key? key}) : super(key: key);

  // Método createState() que devuelve el estado de la página principal
  @override
  State<HomePage> createState() => _HomePageState();
}

// Clase _HomePageState que maneja el estado de la página principal
class _HomePageState extends State<HomePage> {
  // Instancia de la base de datos de Firestore
  final FirebaseFirestore database = FirebaseFirestore.instance;

  // Función que devuelve un Stream de QuerySnapshot de la colección "jobs"
  Stream<QuerySnapshot> fetchJobsStream() {
    return database.collection('jobs').snapshots();
  }

  // Método build() que construye la estructura de la página principal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Barra de navegación personalizada
        appBar: CustomAppBar(showBackArrow: false,),
        // Cajón lateral personalizado
        endDrawer: CustomDrawer(),
        // Cuerpo de la página principal
        body: Column(children: [
          // Encabezado de la página
          const Padding(
            padding: EdgeInsets.only(top: 60.0),
            child: Text(
              "Algunos trabajos realizados:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          // Lista horizontal de trabajos
          Padding(
            padding: const EdgeInsets.only(top: 68.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 60.0),
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
                              final job = jobs[index].data()
                                  as Map<String, dynamic>;
                              return SizedBox(
                                  width: 150,
                                  child: CardImageWidget(trabajo: job));
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
        ]));
  }
}
