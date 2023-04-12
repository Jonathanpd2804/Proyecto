import '../../exports.dart';

class CreateCitaPage extends StatefulWidget {
  final String clienteUid;
  final dynamic user;
  final String clienteEmail;
  final DateTime? selectedDay;
  TimeOfDay? selectedTime;

  CreateCitaPage({
    required this.user,
    required this.clienteUid,
    this.selectedDay,
    required this.clienteEmail,
  });

  @override
  State<CreateCitaPage> createState() => _CreateCitaPageState();
}

class _CreateCitaPageState extends State<CreateCitaPage> {
  final tituloController = TextEditingController();
  final descripcionController = TextEditingController();

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime != null) {
      setState(() {
        widget.selectedTime = newTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackArrow: true,
      ),
      endDrawer: CustomDrawer(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Crear nueva cita",
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
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Row(
              children: [
                Text(
                  "Fecha: ${widget.selectedDay != null ? widget.selectedDay!.toLocal().toString().split(' ')[0] : ''}",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                InkWell(
                  onTap: _selectTime,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: Icon(Icons.edit),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: ElevatedButton(
              onPressed: () async {
                if (widget.selectedDay != null && widget.selectedTime != null) {
                  final DateTime dateTime = DateTime(
                      widget.selectedDay!.year,
                      widget.selectedDay!.month,
                      widget.selectedDay!.day,
                      widget.selectedTime!.hour,
                      widget.selectedTime!.minute);

                  CreateCita Cita = CreateCita(
                    tituloController: tituloController,
                    descripcionController: descripcionController,
                    fecha: dateTime,
                    cliente: widget.clienteUid,
                    clienteEmail: widget.clienteEmail,
                  );

                  try {
                    await Cita.addCitaToDatabase();

                    // Volver a la pantalla anterior
                    Navigator.pop(context);

                    // Opcional: Mostrar un mensaje
                  } catch (e) {
// Manejar el error, como mostrar un mensaje de error
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                // Personaliza el color de fondo
                // ignore: deprecated_member_use
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
