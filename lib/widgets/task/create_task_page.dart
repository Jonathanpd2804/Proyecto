// ignore_for_file: deprecated_member_use, use_build_context_synchronously, empty_catches

import '../../exports.dart';
import 'package:intl/intl.dart';

class CreateTaskPage extends StatefulWidget {
  final String workerUid;
  final dynamic user;
  final String workerEmail;
  final DateTime? selectedDay;

  const CreateTaskPage({super.key, 
    required this.user,
    required this.workerUid,
    this.selectedDay,
    required this.workerEmail,
  });

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final tituloController = TextEditingController();
  final descripcionController = TextEditingController();
  late TimeOfDay selectedTime;

  bool _esImportante = false;

  @override
  void initState() {
    super.initState();
    selectedTime = TimeOfDay.now();
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
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Crear nueva tarea",
              style: TextStyle(fontSize: 26),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          MyTextField(
              controller: tituloController,
              hintText: "Título",
              obscureText: false),
          const SizedBox(
            height: 20,
          ),
          MyTextField(
              controller: descripcionController,
              hintText: "Descripción",
              obscureText: false),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: 150,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 20),
                    child: Text(
                      "Fecha: ${DateFormat.yMd().format(widget.selectedDay!).replaceAll('/', '-')}",
                      style: TextStyle(color: Colors.grey[500], fontSize: 16),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => selectTime(context),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
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
          CheckboxListTile(
            title: const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text("Importante"),
            ),
            value: _esImportante,
            onChanged: (bool? value) {
              setState(() {
                _esImportante = value!;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: ElevatedButton(
              onPressed: () async {
                DateTime fechaHora = DateTime(
                  widget.selectedDay!.year,
                  widget.selectedDay!.month,
                  widget.selectedDay!.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );

                CreateTask task = CreateTask(
                  tituloController: tituloController,
                  descripcionController: descripcionController,
                  fecha: fechaHora,
                  importante: _esImportante,
                  worker: widget.workerUid,
                  workerEmail: widget.workerEmail,
                  autorEmail: widget.user.email,
                );


                try {
                  await task.addTaskToDatabase();

                  // Volver a la pantalla anterior
                  Navigator.pop(context);

                } catch (e) {
                }
              },
              style: ElevatedButton.styleFrom(
                // Personaliza el color de fondo
                primary: myColor,
                // Personaliza el tamaño del botón
                minimumSize: const Size(150, 50),
                // Personaliza el borde del botón
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Crear'),
            ),
          )
        ],
      ),
    );
  }
}
