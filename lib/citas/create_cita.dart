import '../exports.dart';

class CreateCita {
  final TextEditingController tituloController;
  final TextEditingController descripcionController;
  final DateTime? fecha;
  final String cliente;
  final String clienteEmail;

  CreateCita({
    required this.tituloController,
    required this.descripcionController,
    required this.fecha,
    required this.cliente,
    required this.clienteEmail,
  });

  Future<void> addCitaToDatabase() async {
    if (!isTitleValid()) {
      throw Exception('Título inválido');
    }

    if (!isDescriptionValid()) {
      throw Exception('Descripción inválida');
    }

    await FirebaseFirestore.instance.collection('citas').add({
      'Título': tituloController.text.trim(),
      'Descripción': descripcionController.text.trim(),
      'Fecha': fecha!.toLocal(),
      'Realizada': false,
      'Cliente': cliente,
    });
  }

  bool isTitleValid() {
    return tituloController.text.trim().isNotEmpty;
  }

  bool isDescriptionValid() {
    return descripcionController.text.trim().isNotEmpty;
  }
}
