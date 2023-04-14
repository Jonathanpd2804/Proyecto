import 'package:intl/intl.dart';

import '../exports.dart';

class ShowQuoteDialog extends StatefulWidget {
  final DocumentSnapshot quote;

  const ShowQuoteDialog({Key? key, required this.quote}) : super(key: key);

  @override
  ShowQuoteDialogState createState() => ShowQuoteDialogState();
}

class ShowQuoteDialogState extends State<ShowQuoteDialog> {
  TextEditingController addresController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  bool isImportant = false;
  bool isDone = false;

  @override
  void initState() {
    super.initState();
    addresController.text = widget.quote['Dirección'];
    final dateTimestamp = widget.quote['Fecha'] as Timestamp;
    final dateDateTime = dateTimestamp.toDate();
    final dateString = DateFormat('dd/MM/yyyy').format(dateDateTime);
    dateController.text = dateString;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cita : ${dateController.text}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    'Dirección: ${addresController.text}',
                    style: const TextStyle(fontSize: 16.0),
                    softWrap:
                        true, // Ajusta el texto automáticamente al ancho disponible
                  ),
                ),
              ],
            ),
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
