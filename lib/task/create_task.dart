import '../exports.dart';

class CreateTask {
  final TextEditingController tituloController;
  final TextEditingController descripcionController;
  final DateTime? fecha;
  final bool importante;
  final String worker;
  final String workerEmail;
  final String autorEmail;

  

  CreateTask({
    required this.tituloController,
    required this.descripcionController,
    required this.fecha,
    required this.importante,
    required this.worker,
    required this.workerEmail,
    required this.autorEmail,
  });

  Future<void> addTaskToDatabase() async {
    if (!isTitleValid()) {
      throw Exception('Título inválido');
    }

    if (!isDescriptionValid()) {
      throw Exception('Descripción inválida');
    }

    bool asignada = autorEmail == workerEmail;

    await FirebaseFirestore.instance.collection('tareas').add({
      'Título': tituloController.text.trim(),
      'Descripción': descripcionController.text.trim(),
      'Fecha': fecha!.toUtc(),
      'Importante': importante,
      'Realizada': false,
      'Trabajador': worker,
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
