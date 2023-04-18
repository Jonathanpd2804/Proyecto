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

  void deleteTask() async {
    final citaId = widget.quote.id; //Obtener el id de la cita

    //Obtener una referencia a la colección "tareas" y filtrar por el IdCita:
    final tasksCollection = FirebaseFirestore.instance.collection('tareas');
    final tasksQuery = tasksCollection.where('IdCita', isEqualTo: citaId);

    //Borrar todas las tareas que coincidan con la consulta anterior:
    final tasks = await tasksQuery.get();
    final batch = FirebaseFirestore.instance.batch();
    tasks.docs.forEach((doc) {
      batch.delete(doc.reference);
    });
    await batch.commit();
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
              deleteTask();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
