import 'package:intl/intl.dart';

import '../exports.dart';

class DeleteQuoteDialog extends StatefulWidget {
  final DocumentSnapshot quote;

  const DeleteQuoteDialog({Key? key, required this.quote}) : super(key: key);

  @override
  DeleteQuoteDialogState createState() => DeleteQuoteDialogState();
}

class DeleteQuoteDialogState extends State<DeleteQuoteDialog> {
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

  void deleteQuote() {
    widget.quote.reference.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackArrow: true,
      ),
      endDrawer: CustomDrawer(),
      body: AlertDialog(
        title: const Text("¿Estás seguro de que quieres borrar esta cita?"),
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
              deleteQuote();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
