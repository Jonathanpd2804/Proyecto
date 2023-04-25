import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:david_perez/exports.dart';
import 'package:flutter/material.dart';

class ListReservas extends StatelessWidget {
  const ListReservas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showBackArrow: true),
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

          final reservas = snapshot.data!.docs;

          if (reservas.isEmpty) {
            return const Center(child: Text('No hay reservas realizadas'));
          }

          return ListView.builder(
            itemCount: reservas.length,
            itemBuilder: (BuildContext context, int index) {
              final reserva = reservas[index];
              final String fecha = reserva['fechaReserva'].toDate().toString();
              final String clienteEmail = reserva['clienteEmail'];
              final String productoId = reserva['productoId'];
              bool pagado = reserva['pagado'];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text('Reserva del $fecha'),
                        subtitle: Text('Cliente: $clienteEmail'),
                        trailing: Text(pagado ? 'Pagado' : 'Pendiente'),
                      ),
                      // ElevatedButton(
                      //   onPressed: () async {
                      //     final productoSnapshot = await FirebaseFirestore.instance
                      //         .collection('productos')
                      //         .doc(productoId)
                      //         .get();
                      //     final producto = productoSnapshot.data();
                      //     // Navigator.push(
                      //     //   context,
                      //     //   MaterialPageRoute(
                      //     //     builder: (context) =>
                      //     //         ProductoDetalleScreen(producto: producto),
                      //     //   ),
                      //     // );
                      //   },
                      //   child: const Text('Ver producto'),
                      // ),
                      const SizedBox(height: 8.0),
                      if (!pagado)
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
                                  .doc(reserva.id)
                                  .update({'pagado': true});
                            }
                          },
                          child: const Text('Marcar como pagado'),
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                        ),
                      if (pagado)
                        ElevatedButton(
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
                                  .doc(reserva.id)
                                  .delete();
                            }
                          },
                          child: const Text('Entregado'),
                          style: pagado
                              ? ElevatedButton.styleFrom(primary: Colors.green)
                              : null,
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
