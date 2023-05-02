// ignore_for_file: deprecated_member_use

import 'package:intl/intl.dart';

import '../../exports.dart';

class ShowBookingDialog extends StatefulWidget {
  final DocumentSnapshot booking;

  const ShowBookingDialog({Key? key, required this.booking}) : super(key: key);

  @override
  ShowBookingDialogState createState() => ShowBookingDialogState();
}

class ShowBookingDialogState extends State<ShowBookingDialog> {
  TextEditingController dateController = TextEditingController();
  TextEditingController productController = TextEditingController();
  bool isPaid = false;

  @override
  void initState() {
    super.initState();
    final dateTimestamp = widget.booking['fechaReserva'] as Timestamp;
    final dateDateTime = dateTimestamp.toDate();
    final dateString = DateFormat('dd/MM/yyyy').format(dateDateTime);
    dateController.text = dateString;
    productController.text = widget.booking["productoId"];
  }

  Future<Map<String, dynamic>?> getProductData(String productId) async {
    final doc = await getProductById(productId);
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  Future<DocumentSnapshot> getProductById(String productId) async {
    final doc = await FirebaseFirestore.instance
        .collection('productos')
        .doc(productId)
        .get();

    return doc;
  }

  void _showFlipCardDialog(BuildContext context, Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Stack(alignment: Alignment.center, children: [
                  Opacity(
                    opacity: 0.5,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    height: 300,
                    child: FlipCard(
                      fill: Fill.fillBack,
                      direction: FlipDirection.HORIZONTAL,
                      side: CardSide.FRONT,
                      front: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 8,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: Stack(children: [
                                Image.network(
                                  product['ImagenURL'],
                                  fit: BoxFit.cover,
                                  width: 200,
                                  height: 225,
                                ),
                              ]),
                            ),
                            const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Icon(Icons.touch_app))
                          ],
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
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    child: Divider(
                                        thickness: 1, color: Colors.black87),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Scrollbar(
                                      child: SizedBox(
                                        height: 90, // Altura del contenedor
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
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
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Scrollbar(
                                      child: SizedBox(
                                        height: 20, // Altura del contenedor
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: SingleChildScrollView(
                                            child: Text(
                                              product["Precio"],
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
                    ),
                  )
                ])));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Reserva : ${dateController.text}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    'Producto: ${productController.text}',
                    style: const TextStyle(fontSize: 16.0),
                    softWrap:
                        true, // Ajusta el texto automáticamente al ancho disponible
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      'Pagado 50%: ${isPaid ? "SI" : "NO"}',
                      style: const TextStyle(fontSize: 16.0),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            getProductData(productController.text).then((product) {
              _showFlipCardDialog(context, product!);
            });
          },
          child: const Text('Ver producto'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        
      ],
    );
  }
}
