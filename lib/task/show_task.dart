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
  TextEditingController addressController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  bool isImportant = false;
  bool isDone = false;

  @override
  void initState() {
    super.initState();
    // Obtiene los datos de la tarea y los asigna a las variables correspondientes
    Map<String, dynamic>? data = widget.task.data() as Map<String, dynamic>?;
    titleController.text = data?['Título'] ?? '';
    descriptionController.text = data?['Descripción'] ?? '';
    isImportant = data?['Importante'] ?? false;
    isDone = data?['Realizada'] ?? false;
    addressController.text = data?['Dirección'] ?? '';

    // Convertir la fecha en String
    final dateTimestamp = data?['Fecha'] as Timestamp;
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
            if (descriptionController.text.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Descripción: ${descriptionController.text}',
                      style: const TextStyle(fontSize: 16.0),
                      softWrap:
                          true,
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
                          true, 
                    ),
                  ),
                ],
              ),
            ),
            if (addressController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Dirección: ${addressController.text}',
                        style: const TextStyle(fontSize: 16.0),
                        softWrap:
                            true, 
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        if (addressController.text.isNotEmpty) ...[
          TextButton(
            onPressed: () async {
              String address = addressController.text;
              String url =
                  'https://www.google.com/maps/search/?api=1&query=$address';
              if (await canLaunch(url)) {
                await launch(url);
              } 
            },
            child: const Text('Ver dirección'),
          ),
        ],
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
