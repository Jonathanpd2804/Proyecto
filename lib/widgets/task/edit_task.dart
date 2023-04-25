import 'package:intl/intl.dart';

import '../../exports.dart';

class EditTaskDialog extends StatefulWidget {
  final DocumentSnapshot task;

  const EditTaskDialog({Key? key, required this.task}) : super(key: key);

  @override
  EditTaskDialogState createState() => EditTaskDialogState();
}

class EditTaskDialogState extends State<EditTaskDialog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  late TimeOfDay selectedTime;

  bool isImportant = false;
  bool isDone = false;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.task['Título'];
    descriptionController.text = widget.task['Descripción'];
    isImportant = widget.task['Importante'];
    isDone = widget.task['Realizada'];
    final dateTimestamp = widget.task['Fecha'] as Timestamp;
    final dateDateTime = dateTimestamp.toDate();
    final dateString = DateFormat('dd/MM/yyyy').format(dateDateTime);
    dateController.text = dateString;

    // Obtiene la hora guardada de la tarea
    final hour = dateDateTime.hour;
    final minute = dateDateTime.minute;

    // Establece la hora seleccionada en función de la hora guardada
    selectedTime = TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBackArrow: true,
      ),
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
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                    ),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: dateController,
                          decoration: const InputDecoration(
                            labelText: 'Fecha',
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () => selectTime(context),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(myColor),
                              ),
                              child: const Text('Seleccionar Hora'),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Hora seleccionada: ${DateFormat.Hm().format(DateTime(2023, 4, 19, selectedTime.hour, selectedTime.minute))}',
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Importante'),
                      Switch(
                        value: isImportant,
                        onChanged: (value) {
                          setState(() {
                            isImportant = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Realizada'),
                      Switch(
                        value: isDone,
                        onChanged: (value) {
                          setState(() {
                            isDone = value;
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DeleteTaskDialog(task: widget.task);
                    },
                  );
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
              DateTime selectedDate =
                  DateFormat('dd/MM/yyyy').parse(dateController.text);
              DateTime selectedDateTime = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime.hour,
                selectedTime.minute,
              );

              String selectedDateTimeString =
                  DateFormat('yyyy-MM-dd H:mm').format(selectedDateTime);

              widget.task.reference.update({
                'Título': titleController.text,
                'Descripción': descriptionController.text,
                'Fecha':
                    Timestamp.fromDate(DateTime.parse(selectedDateTimeString)),
                'Importante': isImportant,
                'Realizada': isDone,
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
