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
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
