import '../../exports.dart';

class DeleteBookingDialog extends StatefulWidget {
  final DocumentSnapshot booking;

  const DeleteBookingDialog({Key? key, required this.booking})
      : super(key: key);

  @override
  DeleteBookingDialogState createState() => DeleteBookingDialogState();
}

class DeleteBookingDialogState extends State<DeleteBookingDialog> {
  void deleteBooking() {
    widget.booking.reference.delete();
  }

  void deleteTask() async {
    final bookingId = widget.booking.id; //Obtener el id de la reserva

    //Obtener una referencia a la colección "reservas" y filtrar por el bookingId:

    final bookingsCollection =
        FirebaseFirestore.instance.collection('reservas');
    final querySnapshot =
        await bookingsCollection.where('bookingId', isEqualTo: bookingId).get();
    final booking = querySnapshot.docs;

    final batch = FirebaseFirestore.instance.batch();
    for (var doc in booking) {
      batch.delete(doc.reference);
    }

    await batch.commit();
    await widget.booking.reference.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBackArrow: true,
      ),
      endDrawer: CustomDrawer(),
      body: AlertDialog(
        title: const Text("¿Estás seguro de que quieres borrar esta reserva?"),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Borrar"),
            onPressed: () {
              deleteBooking();
              final productoRef = FirebaseFirestore.instance
                  .collection('productos')
                  .doc(widget.booking["productoId"]);
              final cantidadReservada = widget.booking["cantidad"];
              productoRef.update(
                  {'Cantidad': FieldValue.increment(cantidadReservada)});

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
