// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables, avoid_print, use_build_context_synchronously

import 'dart:io';

import '../../exports.dart';

class EditJob extends StatefulWidget {
  final job;

  EditJob({super.key, required this.job});

  @override
  State<EditJob> createState() => _EditJobState();
}

class _EditJobState extends State<EditJob> {
  late String _title;
  late String _description;
  File? _image;
  String? _imageUrlFromDatabase;
  late String jobID;
  final _formKey = GlobalKey<FormState>();

  final CollectionReference jobsCollection =
      FirebaseFirestore.instance.collection('trabajos');

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<String?> _uploadImageToStorage(String imageUrl) async {
    try {
      await _deletePreviousImage(imageUrl);
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('Trabajos/${_image!.path.split('/').last}');
      final uploadTask = storageRef.putFile(_image!);
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      // Aquí se maneja la excepción y se devuelve null en caso de error
      print("Error al subir la imagen: $e");
      return null;
    }
  }

  Future<void> _deletePreviousImage(String imageUrl) async {
    final previousImageRef = FirebaseStorage.instance.refFromURL(imageUrl);
    await previousImageRef.delete();
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Guardando cambios..."),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImage() {
    return Container(
      width: 150,
      height: 500,
      decoration: BoxDecoration(
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: _image != null
              ? FileImage(_image!)
              : NetworkImage(_imageUrlFromDatabase!) as ImageProvider<Object>,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobData = widget.job.data();

    _title = jobData['Título'];
    _description = jobData['Descripción'];
    _imageUrlFromDatabase = jobData['ImagenURL'];
    jobID = widget.job.id;

    return Scaffold(
      appBar: const CustomAppBar(showBackArrow: true),
      endDrawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildImage(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Galería'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(myColor),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.photo_camera),
                    label: const Text('Cámara'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(myColor),
                    ),
                  ),
                ],
              ),
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(
                  labelText: 'Título',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese un título válido';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese una descripción válida';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(myColor),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    _showLoadingDialog(context); // Muestra el diálogo de carga

                    if (_image != null) {
                      final newImageUrl =
                          await _uploadImageToStorage(_imageUrlFromDatabase!);
                      if (newImageUrl != null) {
                        _imageUrlFromDatabase = newImageUrl;
                      } else {
                        Navigator.pop(
                            context); // Cierra el diálogo de carga en caso de error
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Error al subir la imagen. Por favor, inténtalo de nuevo.'),
                          ),
                        );
                        return;
                      }
                    }

                    await FirebaseFirestore.instance
                        .collection('productos')
                        .doc(jobID)
                        .update({
                      'Título': _title,
                      'Descripción': _description,
                      'ImagenURL': _imageUrlFromDatabase,
                    });

                    Navigator.pop(context); // Cierra el diálogo de carga
                    Navigator.pop(context); // Regresa a la pantalla anterior
                  }
                },
                child: const Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
