import 'package:intl/intl.dart';

import '../exports.dart';

class ShowTaskDialog extends StatefulWidget {
  final DocumentSnapshot task;

  const ShowTaskDialog({Key? key, required this.task}) : super(key: key);

  @override
  ShowTaskDialogState createState() => ShowTaskDialogState();
}

class ShowTaskDialogState extends State<ShowTaskDialog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  bool isImportant = false;
  bool isDone = false;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.task['Título'];
    descriptionController.text = widget.task['Descripción'];
    isImportant = widget.task['Importante'];
    isDone = widget.task['Realizada'];

    //Convertir la fecha en String
    final dateTimestamp = widget.task['Fecha'] as Timestamp;
    final dateDateTime = dateTimestamp.toDate();
    final dateString = DateFormat('dd/MM/yyyy').format(dateDateTime);
    dateController.text = dateString;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tarea : ${titleController.text}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Descripción: ${descriptionController.text}',
                    style: const TextStyle(fontSize: 16.0),
                    softWrap:
                        true, // Ajusta el texto automáticamente al ancho disponible
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Fecha: ${dateController.text}',
                      style: const TextStyle(fontSize: 16.0),
                      softWrap:
                          true, // Ajusta el texto automáticamente al ancho disponible
                    ),
                  ),
                ],
              ),
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
