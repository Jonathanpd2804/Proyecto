// ignore_for_file: deprecated_member_use

import '../exports.dart';

class ListBookings extends StatelessWidget {
  const ListBookings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showBackArrow: true),
      drawer: CustomDrawer(),
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
              bool paid = booking['pagado'];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text('Reserva del $date'),
                        subtitle: Text('Cliente: $clientEmail'),
                        trailing: Text(paid ? 'Pagado' : 'Pendiente'),
                      ),
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('productos')
                            .doc(productId)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError || !snapshot.hasData) {
                            return const Text('Cargando producto...');
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Producto: $productId"),
                              Padding(
                                padding: const EdgeInsets.only(left: 40.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navegar a la pantalla de detalles del producto
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              myColor)),
                                  child: const Text('Ver producto'),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 8.0),
                      if (!paid)
                        ElevatedButton(
                          onPressed: () async {
                            final confirmado = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirmar pago'),
                                  content: const Text(
                                      '¿Está seguro de que desea marcar esta reserva como pagada?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: const Text('Sí'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: const Text('No'),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (confirmado != null && confirmado) {
                              await FirebaseFirestore.instance
                                  .collection('reservas')
                                  .doc(booking.id)
                                  .update({'pagado': true});
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: const Text('Marcar como pagado'),
                        ),
                      if (paid)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  final confirmado = await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirmar entrega'),
                                        content: const Text(
                                          '¿Está seguro de que desea marcar esta reserva como entregada y eliminarla?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            },
                                            child: const Text('Sí'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            child: const Text('No'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  if (confirmado != null && confirmado) {
                                    await FirebaseFirestore.instance
                                        .collection('reservas')
                                        .doc(booking.id)
                                        .delete();
                                  }
                                },
                                style: paid
                                    ? ElevatedButton.styleFrom(
                                        fixedSize: const Size(113, 25),
                                        primary: Colors.white,
                                        onPrimary: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: const BorderSide(
                                              color: myColor, width: 3),
                                        ),
                                      )
                                    : null,
                                child: const Text('Entregado'),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
