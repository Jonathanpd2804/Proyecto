
import '../../exports.dart';

class DeleteQuoteDialog extends StatefulWidget {
  final DocumentSnapshot quote;

  const DeleteQuoteDialog({Key? key, required this.quote}) : super(key: key);

  @override
  DeleteQuoteDialogState createState() => DeleteQuoteDialogState();
}

class DeleteQuoteDialogState extends State<DeleteQuoteDialog> {
 


  void deleteQuote() {
    widget.quote.reference.delete();
  }

  void deleteTask() async {
    final citaId = widget.quote.id; //Obtener el id de la cita

    //Obtener una referencia a la colección "tareas" y filtrar por el IdCita:
    final tasksCollection = FirebaseFirestore.instance.collection('citas');
    final tasksQuery = tasksCollection.where('IdCita', isEqualTo: citaId);

    //Borrar todas las tareas que coincidan con la consulta anterior:
    final tasks = await tasksQuery.get();
    final batch = FirebaseFirestore.instance.batch();
    for (var doc in tasks.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    widget.quote.reference.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
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
