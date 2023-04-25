import '../exports.dart';

class JobsCardsRow extends StatelessWidget {
  JobsCardsRow({
    Key? key,
  }) : super(key: key);

  final FirebaseFirestore database = FirebaseFirestore.instance;

  Stream<QuerySnapshot> fetchJobsStream() {
    return database.collection('trabajos').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
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
                        final job = jobs[index].data() as Map<String, dynamic>;
                        return SizedBox(
                            width: 150, child: CardImageWidget(job: job));
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
