import '../exports.dart';

class CreateTask {
  final TextEditingController tituloController;
  final TextEditingController descripcionController;
  final DateTime? fecha;
  final bool importante;
  final String trabajador;
  final String trabajadorEmail;
  final String autorEmail;

  CreateTask({
    required this.tituloController,
    required this.descripcionController,
    required this.fecha,
    required this.importante,
    required this.trabajador,
    required this.trabajadorEmail,
    required this.autorEmail,
  });

  Future<void> addTaskToDatabase() async {
    if (!isTitleValid()) {
      throw Exception('Título inválido');
    }

    if (!isDescriptionValid()) {
      throw Exception('Descripción inválida');
    }

    bool asignada = autorEmail == trabajadorEmail;

    await FirebaseFirestore.instance.collection('tareas').add({
      'Título': tituloController.text.trim(),
      'Descripción': descripcionController.text.trim(),
      'Fecha': fecha!.toUtc(),
      'Importante': importante,
      'Realizada': false,
      'Trabajador': trabajador,
      'Asignada': !asignada,
    });
  }

  bool isTitleValid() {
    return tituloController.text.trim().isNotEmpty;
  }

  bool isDescriptionValid() {
    return descripcionController.text.trim().isNotEmpty;
  }
}
