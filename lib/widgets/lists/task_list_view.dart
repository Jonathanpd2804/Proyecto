import '../../exports.dart';

class TaskListView extends StatelessWidget {
  final String? workerUid; //Trabajador a ver las tareas
  final DateTime? selectedDay; //Día seleccionado
  final bool? isAssigned; //Si la tarea está asignada
  final String? userEmail; //Correo de el usuario actual
  final String workerEmail; //Correo de el trabajador a ver las tareas

  const TaskListView({
    Key? key,
    this.workerUid,
    this.selectedDay,
    this.isAssigned,
    this.userEmail,
    required this.workerEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tareas')
          .where('Trabajador', isEqualTo: workerUid)
          .where('Asignada', isEqualTo: isAssigned)
          .where('Fecha',
              isGreaterThanOrEqualTo: selectedDay != null
                  ? Timestamp.fromDate(DateTime(
                      selectedDay!.year, selectedDay!.month, selectedDay!.day))
                  : Timestamp.fromDate(DateTime(
                      2000, 1, 1))) // fecha de comodín si selectedDay es nulo
          .where('Fecha',
              isLessThan: selectedDay != null
                  ? Timestamp.fromDate(DateTime(selectedDay!.year,
                      selectedDay!.month, selectedDay!.day + 1))
                  : Timestamp.fromDate(DateTime(
                      2100, 1, 1))) // fecha de comodín si selectedDay es nulo
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(
              child: Text('Error al cargar la lista de tareas'));
        }

        final tasks = snapshot.data!.docs;

        if (tasks.isEmpty && selectedDay != null) {
          return const Center(
            child: Text('No hay tareas para este día.'),
          );
        }

        if (tasks.isEmpty && selectedDay == null) {
          return const Center(
            child: Text('No tiene tareas asignadas.'),
          );
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return ListTile(
              title: Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: task['Realizada'] ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        if (task['Importante'])
                          const Icon(Icons.star, color: Colors.yellow),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            task['Título'],
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                        const Spacer(),
                        if (!task["Asignada"] && workerEmail == userEmail)
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: GestureDetector(
                              child: const Icon(Icons.edit),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return EditTaskDialog(task: task);
                                  },
                                );
                              },
                            ),
                          ),
                        if (task["Asignada"] && workerEmail != userEmail)
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: GestureDetector(
                              child: const Icon(Icons.edit),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return EditTaskDialog(task: task);
                                  },
                                );
                              },
                            ),
                          ),
                        if (task["Asignada"] &&
                            !task["Realizada"] &&
                            workerEmail == userEmail)
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: GestureDetector(
                              child: const Icon(Icons.check),
                              onTap: () {
                                DocumentReference tareaRef = FirebaseFirestore
                                    .instance
                                    .collection('tareas')
                                    .doc(task.id);
                                tareaRef.update({'Realizada': true});
                              },
                            ),
                          ),
                        if (task["Asignada"] &&
                            task["Realizada"] &&
                            workerEmail == userEmail)
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: GestureDetector(
                              child: const Icon(Icons.cancel_rounded),
                              onTap: () {
                                DocumentReference tareaRef = FirebaseFirestore
                                    .instance
                                    .collection('tareas')
                                    .doc(task.id);
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
                                return ShowTaskDialog(task: task);
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
