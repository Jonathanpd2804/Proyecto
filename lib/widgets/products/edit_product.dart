// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'dart:io';

import '../../exports.dart';

class EditProduct extends StatefulWidget {
  final product;

  EditProduct({super.key, required this.product});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  late String _title;
  late String _description;
  late String _price;
  late int _cantidad;
  File? _image;
  String? _imageUrlFromDatabase;
  late String productID;
  final _formKey = GlobalKey<FormState>();

  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('productos');

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
          .child('Productos/${_image!.path.split('/').last}');
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
          child: AlertDialog(
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
              ? FileImage(_image!) as ImageProvider<Object>
              : NetworkImage(_imageUrlFromDatabase!) as ImageProvider<Object>,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productData = widget.product.data();

    _title = productData['Título'];
    _description = productData['Descripción'];
    _price = productData['Precio'];
    _cantidad = productData['Cantidad'];
    _imageUrlFromDatabase = productData['ImagenURL'];
    productID = widget.product.id;

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
              TextFormField(
                initialValue: _price.toString(),
                decoration: const InputDecoration(
                  labelText: 'Precio',
                  suffixText: '€',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese un precio válido';
                  }
                  return null;
                },
                onSaved: (value) {
                  _price = value!;
                },
              ),
              TextFormField(
                initialValue: _cantidad.toString(),
                decoration: const InputDecoration(
                  labelText: 'Cantidad',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese una cantidad válida';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cantidad = int.parse(value!);
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
                        _imageUrlFromDatabase = newImageUrl as String?;
                      } else {
                        Navigator.pop(
                            context); // Cierra el diálogo de carga en caso de error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Error al subir la imagen. Por favor, inténtalo de nuevo.'),
                          ),
                        );
                        return;
                      }
                    }

                    await FirebaseFirestore.instance
                        .collection('productos')
                        .doc(productID)
                        .update({
                      'Título': _title,
                      'Descripción': _description,
                      'Precio': _price,
                      'Cantidad': _cantidad,
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
