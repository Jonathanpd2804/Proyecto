import 'package:david_perez/pages/calendarios/calendario_citas_page.dart';

import '../../exports.dart';

class CalendarioCliente extends StatefulWidget {
  final String clienteUid;
  final user = FirebaseAuth.instance.currentUser;

  CalendarioCliente({
    Key? key,
    required this.clienteUid,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CalendarioClienteState createState() => _CalendarioClienteState();
}

class _CalendarioClienteState extends State<CalendarioCliente> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  bool isJefe = false;
  String userUid = "";
  late var clienteEmail = "";

  TextEditingController nameTareaController = TextEditingController();

  Future<List<String>> _getEventsOfDay(DateTime day) async {
    final tasks = await FirebaseFirestore.instance
        .collection('citas')
        .where('Cliente', isEqualTo: widget.clienteUid)
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
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('usuarios')
                  .doc(widget.clienteUid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Text('Cliente no encontrado ${widget.user}');
                }
                final clienteData =
                    snapshot.data!.data() as Map<String, dynamic>;
                final clienteNombre = clienteData['Nombre'];
                clienteEmail = clienteData['Email'];
                return AutoSizeText(
                  "Calendario de $clienteNombre",
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
                    clienteEmail == widget.user?.email
                        ? "Mis citas: "
                        : "Sus citas:",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Expanded(
                      child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.add), // Añade un ícono
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                  'Selecciona horario'), // Título del diálogo
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text(
                                      'Elige el horario al que quieres tu cita'),
                                  SizedBox(height: 16.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // Botón para horario de la mañana
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Cierra el diálogo
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const CalendarioCitasPage(),
                                              ));
                                        },
                                        child: Text('Mañana'),
                                      ),
                                      // Botón para horario de la tarde
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Cierra el diálogo
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const CalendarioCitasPage(),
                                              ));
                                        },
                                        child: Text('Tarde'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ))
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
                child: CitasListView(
                    clienteUid: widget.clienteUid,
                    selectedDay: _selectedDay!,
                    userEmail: widget.user!.email,
                    clienteEmail: clienteEmail)),
          ] else
            const Expanded(
              child: Center(
                child: Text(
                    'Selecciona un día en el calendario para ver las citas.'),
              ),
            ),
        ]),
      );
    });
  }
}
