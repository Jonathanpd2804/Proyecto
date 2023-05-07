import '../../exports.dart';

class CreateTask {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final DateTime? date;
  final bool important;
  final String worker;
  final String workerEmail;
  final String authorEmail;

  CreateTask({
    required this.titleController,
    required this.descriptionController,
    required this.date,
    required this.important,
    required this.worker,
    required this.workerEmail,
    required this.authorEmail,
  });

  Future<void> addTaskToDatabase() async {
    if (!isTitleValid()) {
      throw Exception('Título inválido');
    }

    if (!isDescriptionValid()) {
      throw Exception('Descripción inválida');
    }

    bool asignada = authorEmail == workerEmail;

    await FirebaseFirestore.instance.collection('tareas').add({
      'Título': titleController.text.trim(),
      'Descripción': descriptionController.text.trim(),
      'Fecha': date!.toUtc(),
      'Importante': important,
      'Realizada': false,
      'Trabajador': worker,
      'Asignada': !asignada,
    });
  }

  bool isTitleValid() {
    return titleController.text.trim().isNotEmpty;
  }

  bool isDescriptionValid() {
    return descriptionController.text.trim().isNotEmpty;
  }
}
