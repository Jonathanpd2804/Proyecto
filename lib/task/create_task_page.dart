import '../exports.dart';

class CreateTaskPage extends StatefulWidget {
  final String trabajadorUid;
  final dynamic user;
  final String trabajadorEmail;
  final DateTime? selectedDay;

  CreateTaskPage({
    required this.user,
    required this.trabajadorUid,
    this.selectedDay,
    required this.trabajadorEmail,
  });

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final tituloController = TextEditingController();
  final descripcionController = TextEditingController();
  bool _esImportante = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(showBackArrow: true,),
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
            child: Container(
              width: 340,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 20),
                child: Text(
                  "Fecha: ${widget.selectedDay}",
                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                ),
              ),
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
                CreateTask task = CreateTask(
                  tituloController: tituloController,
                  descripcionController: descripcionController,
                  fecha: widget.selectedDay,
                  importante: _esImportante,
                  trabajador: widget.trabajadorUid,
                  trabajadorEmail: widget.trabajadorEmail,
                  autorEmail: widget.user.email,
                );

                try {
                  await task.addTaskToDatabase();

                  // Volver a la pantalla anterior
                  Navigator.pop(context);

                  // Opcional: Mostrar un mensaje de éxito, por ejemplo, utilizando un SnackBar
                  // final snackBar = SnackBar(content: Text('Tarea creada con éxito'));
                  // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } catch (e) {
                  // Manejar el error, como mostrar un mensaje de error
                }
              },
              child: Text('Crear'),
              style: ElevatedButton.styleFrom(
                // Personaliza el color de fondo
                primary: myColor,
                // Personaliza el tamaño del botón
                minimumSize: Size(150, 50),
                // Personaliza el borde del botón
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
