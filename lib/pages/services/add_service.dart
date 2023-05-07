import 'dart:io';

import '../../exports.dart';

class ServiceForm extends StatefulWidget {
  const ServiceForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ServiceFormState createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isSubmitting = false; //Se está creando el trabajo

  void _submitForm() async {
    setState(() {
      _isSubmitting = true;
    });

    final title = _titleController.text;
    final description = _descriptionController.text;

    final productCollection =
        FirebaseFirestore.instance.collection('servicios');
    final productData = {
      'Título': title,
      'Descripción': description,
    };
    await productCollection.add(productData);

    setState(() {
      _isSubmitting = false;
    });

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
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
                Center(
                  child: ElevatedButton(
                    // ignore: deprecated_member_use
                    style: ElevatedButton.styleFrom(primary: myColor),
                    onPressed: _isSubmitting ? null : _submitForm,
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Crear servicio'),
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
