import 'package:david_perez/exports.dart';

class ComentariosYPuntuacion extends StatefulWidget {
  final currentUser = FirebaseAuth.instance.currentUser; // Usuario actual

  ComentariosYPuntuacion({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ComentariosYPuntuacionState createState() => _ComentariosYPuntuacionState();
}

class _ComentariosYPuntuacionState extends State<ComentariosYPuntuacion> {
  final _comentariosYPuntuaciones =
      FirebaseFirestore.instance.collection('comentariosYPuntuaciones');
  final TextEditingController _comentarioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16.0),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _comentariosYPuntuaciones.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: snapshot.data!.docs.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        child: const Text('No hay comentarios'),
                      )
                    : ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text('${document['Puntuación']}'),
                              ),
                              title: Text(document['Comentario']),
                            ),
                          );
                        }).toList(),
                      ),
              );
            },
          ),
        ),
        if (widget.currentUser != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Añadir comentario",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  _mostrarDialogoPuntuacion(context);
                },
                icon: const Icon(Icons.add_comment),
              ),
            ],
          ),
      ],
    );
  }

  void _mostrarDialogoPuntuacion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar comentario y puntuación'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _comentarioController,
                  decoration:
                      const InputDecoration(hintText: 'Agrega un comentario'),
                ),
                const SizedBox(height: 16.0),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (double value) async {
                    if (_comentarioController.text.isNotEmpty) {
                      bool confirm = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                                '¿Confirmar comentario y puntuación?'),
                            content: Text(
                              'Comentario: ${_comentarioController.text}\nPuntuación: $value',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Confirmar'),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm != null && confirm) {
                        await _comentariosYPuntuaciones.add({
                          'Comentario': _comentarioController.text,
                          'Puntuación': value,
                        });
                        _comentarioController.clear();
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Debes agregar un comentario')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
