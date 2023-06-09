// ignore_for_file: deprecated_member_use

import '../exports.dart';

class ListBookings extends StatefulWidget {
  const ListBookings({Key? key}) : super(key: key);

  @override
  State<ListBookings> createState() => _ListBookingsState();
}

class _ListBookingsState extends State<ListBookings> {
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

  Future<Map<String, dynamic>?> getProductData(String productId) async {
    final doc = await getProductById(productId);
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showBackArrow: true),
      endDrawer: CustomDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('reservas').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Error al cargar los datos');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final bookings = snapshot.data!.docs;

          if (bookings.isEmpty) {
            return const Center(child: Text('No hay reservas realizadas'));
          }

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (BuildContext context, int index) {
              final booking = bookings[index];
              final dateBooking = booking['fechaReserva'].toDate().toLocal();
              final date =
                  '${dateBooking.day}/${dateBooking.month}/${dateBooking.year}';
              final String clientEmail = booking['clienteEmail'];
              final String productId = booking['productoId'];
              final int amount = booking['cantidad'];
              bool paid = booking['pagado'];

              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      color:
                          dateBooking.difference(DateTime.now()).inDays < -3 &&
                                  paid == false
                              ? Colors.red[400]
                              : Colors.white,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Reserva: ${booking.id}'),
                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return DeleteBookingDialog(
                                              booking: booking);
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(113, 25),
                                      primary: Colors.white,
                                      onPrimary: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: const BorderSide(
                                            color: myColor, width: 3),
                                      ),
                                    ),
                                    child: const Text("Borrar"),
                                  )
                                ],
                              ),
                            ),
                            ListTile(
                              title: Text('Reserva del $date'),
                              subtitle: Text('Cliente: $clientEmail'),
                              trailing: Text(paid ? 'Pagado' : 'Pendiente'),
                            ),
                            FutureBuilder<Map<String, dynamic>?>(
                              future: getProductData(productId),
                              builder: (context, snapshot) {
                                Widget productInfo;
                                bool productFound =
                                    !(snapshot.hasError || !snapshot.hasData);

                                if (productFound) {
                                  productInfo = Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Row(
                                      children: [
                                        Text("Producto: $productId"),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Text("Cantidad: $amount"),
                                        )
                                      ],
                                    ),
                                  );
                                } else {
                                  productInfo = const Padding(
                                    padding: EdgeInsets.only(left: 18.0),
                                    child: Text('Producto no encontrado'),
                                  );
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    productInfo,
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, left: 20),
                                      child: ElevatedButton(
                                        onPressed: productFound
                                            ? () {
                                                getProductData(productId)
                                                    .then((product) {
                                                  _showFlipCardDialog(
                                                      context, product!);
                                                });
                                              }
                                            : null, // Desactiva el botón si el producto no se encuentra.
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  myColor),
                                        ),
                                        child: const Text('Ver producto'),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          final confirm =
                                              await showDialog<bool>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(paid
                                                    ? 'Confirmar no pagado'
                                                    : 'Confirmar pago'),
                                                content: Text(paid
                                                    ? '¿Está seguro de que desea marcar esta reserva como no pagada?'
                                                    : '¿Está seguro de que desea marcar esta reserva como pagada?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(true);
                                                    },
                                                    child: const Text('Sí'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(false);
                                                    },
                                                    child: const Text('No'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          if (confirm != null && confirm) {
                                            await FirebaseFirestore.instance
                                                .collection('reservas')
                                                .doc(booking.id)
                                                .update({'pagado': !paid});
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: const Size(113, 25),
                                          primary: Colors.white,
                                          onPrimary: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            side: const BorderSide(
                                                color: myColor, width: 3),
                                          ),
                                        ),
                                        child:
                                            Text(paid ? 'No pagado' : 'Pagado'),
                                      ),
                                    ),
                                    if (paid)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            final confirm =
                                                await showDialog<bool>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Confirmar entrega'),
                                                  content: const Text(
                                                    '¿Está seguro de que desea marcar esta reserva como entregada y eliminarla?',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(true);
                                                      },
                                                      child: const Text('Sí'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      },
                                                      child: const Text('No'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            if (confirm != null && confirm) {
                                              await FirebaseFirestore.instance
                                                  .collection('reservas')
                                                  .doc(booking.id)
                                                  .delete();
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(113, 25),
                                            primary: Colors.white,
                                            onPrimary: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              side: const BorderSide(
                                                  color: myColor, width: 3),
                                            ),
                                          ),
                                          child: const Text('Entregado'),
                                        ),
                                      ),
                                    const SizedBox(height: 16.0),
                                  ],
                                );
                              },
                            ),
                          ])));
            },
          );
        },
      ),
    );
  }
}
