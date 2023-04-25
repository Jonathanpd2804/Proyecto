import '../exports.dart';

class ProductsPage extends StatelessWidget {
  final String productId;

  const ProductsPage({Key? key, required this.productId}) : super(key: key);

  Future<DocumentSnapshot> getProductById(String productId) async {
    final doc = await FirebaseFirestore.instance
        .collection('productos')
        .doc(productId)
        .get();
    return doc;
  }
  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: getProductById(productId),
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error al cargar los datos'));
          }

          final product = snapshot.data!;
          return FlipCard(
            fill: Fill.fillBack,
            direction: FlipDirection.HORIZONTAL,
            side: CardSide.FRONT,
            front: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 8,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.asset(
                  'lib/images/logo.png',
                  fit: BoxFit.cover,
                  width: 150,
                  height: 185,
                ),
              ),
            ),
            back: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 8,
              child: Column(children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Scrollbar(
                          child: SizedBox(
                            height: 45, // Altura del contenedor
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: SingleChildScrollView(
                                child: Text(
                                  product["Título"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Divider(thickness: 1, color: Colors.black87),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Scrollbar(
                            child: SizedBox(
                              height: 90, // Altura del contenedor
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: SingleChildScrollView(
                                  child: Text(
                                    product["Descripción"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Icon(Icons.touch_app),
                )
              ]),
            ),
          );
        });
  }
}

