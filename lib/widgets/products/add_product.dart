import 'dart:io';

import '../../exports.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  File? _image;
  bool _isSubmitting = false; //Se está creand el trabajo
  String? _imageError; //Mensaje de imagen no introducida

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<String> _uploadImageToStorage() async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('Productos/${_image!.path.split('/').last}');
    final uploadTask = storageRef.putFile(_image!);
    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_image == null) {
        setState(() {
          _imageError = 'Por favor, seleccione una imagen';
        });
        return;
      } else {
        setState(() {
          _imageError = null;
        });
      }

      setState(() {
        _isSubmitting = true;
      });

      final title = _titleController.text;
      final description = _descriptionController.text;
      final imageUrl = await _uploadImageToStorage();
      final price = _priceController.text;
      final stock = _stockController.text;

      final productCollection =
          FirebaseFirestore.instance.collection('productos');
      final productData = {
        'Título': title,
        'Descripción': description,
        'ImagenURL': imageUrl,
        'Precio': price,
        'Cantidad' : stock
      };
      await productCollection.add(productData);

      setState(() {
        _isSubmitting = false;
      });

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBackArrow: true,
      ),
      endDrawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_image != null)
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          // ignore: deprecated_member_use
                          primary: myColor // Cambia el color aquí
                          ),
                      onPressed: () => _pickImage(ImageSource.camera),
                      child: const Text('Cámara'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          // ignore: deprecated_member_use
                          primary: myColor // Cambia el color aquí
                          ),
                      onPressed: () => _pickImage(ImageSource.gallery),
                      child: const Text('Galería'),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                if (_imageError != null)
                  Text(
                    _imageError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingrese un título';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingrese una descripción';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Precio',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingrese una precio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _stockController,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingrese una precio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    // ignore: deprecated_member_use
                    style: ElevatedButton.styleFrom(primary: myColor),
                    onPressed: _isSubmitting ? null : _submitForm,
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Crear producto'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
