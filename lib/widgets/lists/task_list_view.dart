import '../../exports.dart';

class TaskListView extends StatelessWidget {
  final String trabajadorUid;
  final DateTime selectedDay;
  final bool isAssigned;
  final String? userEmail;
  final String trabajadorEmail;

  const TaskListView({
    Key? key,
    required this.trabajadorUid,
    required this.selectedDay,
    required this.isAssigned,
    required this.userEmail,
    required this.trabajadorEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tareas')
          .where('Trabajador', isEqualTo: trabajadorUid)
          .where('Asignada', isEqualTo: isAssigned)
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
          return const Center(
              child: Text('Error al cargar la lista de tareas'));
        }

        final tareas = snapshot.data!.docs;

        if (tareas.isEmpty) {
          return const Center(
            child: Text('No hay tareas para este día.'),
          );
        }

        return ListView.builder(
          itemCount: tareas.length,
          itemBuilder: (context, index) {
            final tarea = tareas[index];
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
                        if (tarea['Importante'])
                          const Icon(Icons.star, color: Colors.yellow),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            tarea['Título'],
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                        const Spacer(),
                        if (!tarea["Asignada"] && trabajadorEmail == userEmail)
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
                        if (tarea["Asignada"] && trabajadorEmail != userEmail)
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
                        if (tarea["Asignada"] &&
                            !tarea["Realizada"] &&
                            trabajadorEmail == userEmail)
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: GestureDetector(
                              child: const Icon(Icons.check),
                              onTap: () {
                                DocumentReference tareaRef = FirebaseFirestore
                                    .instance
                                    .collection('tareas')
                                    .doc(tarea.id);
                                tareaRef.update({'Realizada': true});
                              },
                            ),
                          ),
                        if (tarea["Asignada"] &&
                            tarea["Realizada"] &&
                            trabajadorEmail == userEmail)
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: GestureDetector(
                              child: const Icon(Icons.cancel_rounded),
                              onTap: () {
                                DocumentReference tareaRef = FirebaseFirestore
                                    .instance
                                    .collection('tareas')
                                    .doc(tarea.id);
                                tareaRef.update({'Realizada': false});
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
