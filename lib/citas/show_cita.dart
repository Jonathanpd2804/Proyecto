import '../exports.dart';

class ShowTaskDialog extends StatefulWidget {
  final DocumentSnapshot task;

  const ShowTaskDialog({Key? key, required this.task}) : super(key: key);

  @override
  _ShowTaskDialogState createState() => _ShowTaskDialogState();
}

class _ShowTaskDialogState extends State<ShowTaskDialog> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool _isImportant = false;
  bool _isDone = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task['Título'];
    _descriptionController.text = widget.task['Descripción'];
    _isImportant = widget.task['Importante'];
    _isDone = widget.task['Realizada'];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tarea : ${_titleController.text}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    'Descripción: ${_descriptionController.text}',
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
