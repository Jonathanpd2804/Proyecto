import '../exports.dart';

class EditTaskDialog extends StatefulWidget {
  final DocumentSnapshot task;

  const EditTaskDialog({Key? key, required this.task}) : super(key: key);

  @override
  _EditTaskDialogState createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
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

  void _deleteTask() {
    widget.task.reference.delete();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(showBackArrow: true,),
      endDrawer: CustomDrawer(),
      body: AlertDialog(
        title: const Text('Editar Tarea'),
        content: Builder(
          builder: (context) {
            // Obtén el MediaQueryData para saber la altura del teclado
            final mediaQuery = MediaQuery.of(context);
            return SingleChildScrollView(
              // Ajusta el espacio para el teclado
              padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                    ),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Importante'),
                      Switch(
                        value: _isImportant,
                        onChanged: (value) {
                          setState(() {
                            _isImportant = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Realizada'),
                      Switch(
                        value: _isDone,
                        onChanged: (value) {
                          setState(() {
                            _isDone = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 60.0, bottom: 10),
            child: IconButton(
                onPressed: () {
                  _deleteTask();
                },
                icon: const Icon(Icons.delete)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              widget.task.reference.update({
                'Título': _titleController.text,
                'Descripción': _descriptionController.text,
                'Importante': _isImportant,
                'Realizada': _isDone,
              });
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
