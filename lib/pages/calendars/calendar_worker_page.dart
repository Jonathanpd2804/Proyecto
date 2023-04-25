import '../../exports.dart';

class CalendarWorker extends StatefulWidget {
  final String workerUid; //Id de el worker
  final user = FirebaseAuth.instance.currentUser; //Usuario actual

  CalendarWorker({
    Key? key,
    required this.workerUid,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CalendarWorkerState createState() => _CalendarWorkerState();
}

class _CalendarWorkerState extends State<CalendarWorker> {
  late CalendarFormat calendarFormat; //Formato de el calendario
  late DateTime _focusedDay;
  DateTime? _selectedDay; //Día seleccionado
  late var workerEmail = ""; //Email de el worker

  Future<List<String>> getEventsOfDay(DateTime day) async {
    final tasks = await FirebaseFirestore.instance
        .collection('tareas')
        .where('Trabajador', isEqualTo: widget.workerUid)
        .where('Realizada', isEqualTo: false)
        .where('Fecha', isGreaterThanOrEqualTo: Timestamp.fromDate(day.toUtc()))
        .where('Fecha',
            isLessThan: Timestamp.fromDate(
                DateTime(day.year, day.month, day.day + 1).toUtc()))
        .get();

    return tasks.docs.map((doc) => doc['Título'] as String).toList();
  }

  @override
  void initState() {
    super.initState();
    calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
  }

  Future<bool> dayHasTasks(DateTime day) async {
    final tasks = await getEventsOfDay(day);
    return tasks.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBackArrow: true,
      ),
      endDrawer: CustomDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('usuarios')
                  .doc(widget.workerUid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Text('Trabajador no encontrado');
                }
                final workerData =
                    snapshot.data!.data() as Map<String, dynamic>;
                final workerNombre = workerData['Nombre'];
                workerEmail = workerData['Email'];
                return AutoSizeText(
                  "Calendario de $workerNombre",
                  minFontSize: 20,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: TableCalendar(
              calendarFormat: calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  calendarFormat = format;
                });
              },
              focusedDay: _focusedDay,
              firstDay: DateTime(2020),
              lastDay: DateTime(2030),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, events) {
                  return FutureBuilder<bool>(
                    future: dayHasTasks(day),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data == true) {
                        return Stack(
                          children: [
                            Center(child: Text(day.day.toString())),
                            Positioned(
                              top: 10.0,
                              right: 10.0,
                              child: Container(
                                width: 8.0,
                                height: 8.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(255, 245, 23, 8),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container(
                          alignment: Alignment.center,
                          child: Text(day.day.toString()),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ),
          if (_selectedDay != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                children: [
                  Text(
                    workerEmail == widget.user?.email
                        ? "Mis tareas:"
                        : "Sus tareas:",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Expanded(
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateTaskPage(
                                          user: widget.user,
                                          workerEmail: workerEmail,
                                          workerUid: widget.workerUid,
                                          selectedDay: _selectedDay,
                                        )),
                              );
                            },
                            icon: const Icon(Icons.add))),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TaskListView(
                  workerUid: widget.workerUid,
                  selectedDay: _selectedDay!,
                  isAssigned: false,
                  userEmail: widget.user!.email,
                  workerEmail: workerEmail),
            ),
          ] else
            const Expanded(
              child: Center(
                child: Text(
                    'Selecciona un día en el calendario para ver las tareas.'),
              ),
            ),
          if (_selectedDay != null) ...[
            const Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Tareas asignadas:",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TaskListView(
                workerUid: widget.workerUid,
                selectedDay: _selectedDay!,
                isAssigned: true,
                userEmail: widget.user!.email,
                workerEmail: workerEmail,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
