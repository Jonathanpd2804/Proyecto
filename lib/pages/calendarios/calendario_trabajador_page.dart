
import '../../exports.dart';

class CalendarioTrabajador extends StatefulWidget {
  final String trabajadorUid;
  final user = FirebaseAuth.instance.currentUser;

  CalendarioTrabajador({
    Key? key,
    required this.trabajadorUid,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CalendarioTrabajadorState createState() => _CalendarioTrabajadorState();
}

class _CalendarioTrabajadorState extends State<CalendarioTrabajador> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  bool isJefe = false;
  String userUid = "";
  late var trabajadorEmail = "";

  TextEditingController nameTareaController = TextEditingController();

  Future<List<String>> _getEventsOfDay(DateTime day) async {
    final tasks = await FirebaseFirestore.instance
        .collection('tareas')
        .where('Trabajador', isEqualTo: widget.trabajadorUid)
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
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    userUid = widget.user!.uid;
  }

  Future<bool> _dayHasTasks(DateTime day) async {
    final tasks = await _getEventsOfDay(day);
    return tasks.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasData) {
        List<DocumentSnapshot> docs = snapshot.data!.docs;
        if (docs.isNotEmpty) {
          Map<String, dynamic>? userData =
              docs.first.data() as Map<String, dynamic>?;

          if (userData != null && userData.containsKey('Jefe')) {
            isJefe = userData['Jefe'] ?? false;
          }
        }
      }
      return Scaffold(
        appBar: CustomAppBar(showBackArrow: true,),
        endDrawer: CustomDrawer(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('usuarios')
                    .doc(widget.trabajadorUid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text('Trabajador no encontrado ${widget.user}');
                  }
                  final trabajadorData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  final trabajadorNombre = trabajadorData['Nombre'];
                  trabajadorEmail = trabajadorData['Email'];
                  return AutoSizeText(
                    "Calendario de $trabajadorNombre",
                    minFontSize: 20,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: TableCalendar(
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
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
                  // Elimina el estilo predeterminado de los marcadores de eventos
                  outsideDaysVisible: false,
                ),
                // Actualiza el defaultBuilder en calendarBuilders
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, events) {
                    return FutureBuilder<bool>(
                      future: _dayHasTasks(day),
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
                      trabajadorEmail == widget.user?.email
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
                                            trabajadorEmail: trabajadorEmail,
                                            trabajadorUid: widget.trabajadorUid,
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
                    trabajadorUid: widget.trabajadorUid,
                    selectedDay: _selectedDay!,
                    isAssigned: false,
                    userEmail: widget.user!.email,
                    trabajadorEmail: trabajadorEmail),
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
                    Text(
                      "Tareas asignadas:",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TaskListView(
                  trabajadorUid: widget.trabajadorUid,
                  selectedDay: _selectedDay!,
                  isAssigned: true,
                  userEmail: widget.user!.email,
                  trabajadorEmail: trabajadorEmail,
                ),
              ),
            ] else
              const Expanded(
                child: Center(
                  child: Text(
                      'Selecciona un día en el calendario para ver las tareas.'),
                ),
              )
          ],
        ),
      );
    });
  }
}
