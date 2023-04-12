import '../../../exports.dart';

class UserEditor {
  static void editUserName(BuildContext context, String documentId) {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar nombre'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nuevo nombre',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar', style: TextStyle(color: myColor)),
            ),
            TextButton(
              onPressed: () async {
                String newName = nameController.text;
                if (newName.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('usuarios')
                      .doc(documentId)
                      .update({'Nombre': newName});
                }
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text('Guardar', style: TextStyle(color: myColor)),
            ),
          ],
        );
      },
    );
  }

  static void editUserLastName(BuildContext context, String documentId) {
    TextEditingController lastNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar apellidos'),
          content: TextField(
            controller: lastNameController,
            decoration: const InputDecoration(
              labelText: 'Nuevos apellidos',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar', style: TextStyle(color: myColor)),
            ),
            TextButton(
              onPressed: () async {
                String newLastName = lastNameController.text;
                if (newLastName.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('usuarios')
                      .doc(documentId)
                      .update({'Apellidos': newLastName});
                }
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text('Guardar', style: TextStyle(color: myColor)),
            ),
          ],
        );
      },
    );
  }

  static void editUserTelefono(BuildContext context, String documentId) {
    TextEditingController telefonoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar telefono'),
          content: TextField(
            controller: telefonoController,
            decoration: const InputDecoration(
              labelText: 'Nuevo telefono',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar', style: TextStyle(color: myColor)),
            ),
            TextButton(
              onPressed: () async {
                String newTelefono = telefonoController.text;
                if (newTelefono.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('usuarios')
                      .doc(documentId)
                      .update({'Telefono': newTelefono});
                }
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text('Guardar', style: TextStyle(color: myColor)),
            ),
          ],
        );
      },
    );
  }

  static void editUserTurno(BuildContext context, String documentId) {
    String? newTurno;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar turno'),
          content: DropdownButton<String>(
            value: newTurno,
            hint: const Text('Selecciona un turno'),
            items: <String>['Mañana', 'Tarde'].map<DropdownMenuItem<String>>(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList(),
            onChanged: (String? newValue) {
              newTurno = newValue;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar', style: TextStyle(color: myColor)),
            ),
            TextButton(
              onPressed: () async {
                if (newTurno != null) {
                  await FirebaseFirestore.instance
                      .collection('usuarios')
                      .doc(documentId)
                      .update({'Turno': newTurno});
                }
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text('Guardar', style: TextStyle(color: myColor)),
            ),
          ],
        );
      },
    );
  }
}