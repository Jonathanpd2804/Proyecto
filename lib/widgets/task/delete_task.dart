
import '../../exports.dart';

class DeleteTaskDialog extends StatefulWidget {
  final DocumentSnapshot task;

  const DeleteTaskDialog({Key? key, required this.task}) : super(key: key);

  @override
  DeleteTaskDialogState createState() => DeleteTaskDialogState();
}

class DeleteTaskDialogState extends State<DeleteTaskDialog> {
  void deleteQuote() {
    widget.task.reference.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBackArrow: true,
      ),
      endDrawer: CustomDrawer(),
      body: AlertDialog(
        title: const Text("¿Estás seguro de que quieres borrar esta tarea?"),
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
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
