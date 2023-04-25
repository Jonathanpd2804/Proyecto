import '../exports.dart';

class ProductCardWidget extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final product;

  const ProductCardWidget({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      fill: Fill.fillBack,
      direction: FlipDirection.HORIZONTAL,
      side: CardSide.FRONT,
      front: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 8,
          child: Column(children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Stack(
                children: [
                  // Image.network(
                  //   job['ImagenURL'],
                  //   fit: BoxFit.cover,
                  //   width: 150,
                  //   height: 150,
                  // ),
                  Image.asset(
                    'lib/images/logo.png',
                  ),
                  Container(
                    width: 200,
                    height: 225,
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: Text(
                        'Error al cargar la imagen',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
                padding: EdgeInsets.all(18.0), child: Icon(Icons.touch_app))
          ])),
      back: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                              height: 82, // Altura del contenedor
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
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Centrar elementos en el Row

                        children: [
                          Scrollbar(
                            child: SizedBox(
                              height: 15, // Altura del contenedor
                              child: Text(
                                product["Precio"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          // Cambiar el color de fondo del botón

                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          myColor)),
                              onPressed: () {
                                // Acción al presionar el botón "Reservar"
                              },
                              child: const Text("Reservar"),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )),
            const Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Center(child: Icon(Icons.touch_app)),
            )
          ])),
    );
  }
}
