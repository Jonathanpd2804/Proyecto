import '../../exports.dart';

class CitasListView extends StatelessWidget {
  final String clienteUid;
  final DateTime selectedDay;
  final String? userEmail;
  final String clienteEmail;

  const CitasListView({
    Key? key,
    required this.clienteUid,
    required this.selectedDay,
    required this.userEmail,
    required this.clienteEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('citas')
          .where('Cliente', isEqualTo: clienteUid)
          .where('Fecha',
              isGreaterThanOrEqualTo: Timestamp.fromDate(selectedDay))
          .where('Fecha',
              isLessThan: Timestamp.fromDate(DateTime(
                  selectedDay.year, selectedDay.month, selectedDay.day + 1)))
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar la lista de citas'));
        }

        final citas = snapshot.data!.docs;

        if (citas.isEmpty) {
          return const Center(
            child: Text('No hay citas para este día.'),
          );
        }

        return ListView.builder(
          itemCount: citas.length,
          itemBuilder: (context, index) {
            final tarea = citas[index];
            return ListTile(
              title: Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: tarea['Realizada'] ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            tarea['Título'],
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: GestureDetector(
                            child: const Icon(Icons.edit),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return EditTaskDialog(task: tarea);
                                },
                              );
                            },
                          ),
                        ),
                        if (!tarea["Realizada"] && clienteEmail != userEmail)
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: GestureDetector(
                              child: const Icon(Icons.check),
                              onTap: () {
                                DocumentReference tareaRef = FirebaseFirestore
                                    .instance
                                    .collection('citas')
                                    .doc(tarea.id);
                                tareaRef.update({'Realizada': true});
                              },
                            ),
                          ),
                        GestureDetector(
                          child: const Icon(Icons.remove_red_eye),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ShowTaskDialog(task: tarea);
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
