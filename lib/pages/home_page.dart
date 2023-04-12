import '../exports.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> fetchTrabajosStream() {
    return _db.collection('trabajos').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(showBackArrow: false,),
        endDrawer: CustomDrawer(),
        body: Column(children: [
          const Padding(
            padding: EdgeInsets.only(top: 60.0),
            child: Text(
              "Algunos trabajos realizados:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
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
                        stream: fetchTrabajosStream(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return const Center(
                                child: Text('Error al cargar los trabajos'));
                          }

                          List<DocumentSnapshot> trabajos = snapshot.data!.docs;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: trabajos.length,
                            itemBuilder: (BuildContext context, int index) {
                              final trabajo = trabajos[index].data()
                                  as Map<String, dynamic>;
                              // final imageUrl = trabajo['Imagen'] as String;
                              return SizedBox(
                                  width: 150,
                                  child: CardImageWidget(trabajo: trabajo));
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
