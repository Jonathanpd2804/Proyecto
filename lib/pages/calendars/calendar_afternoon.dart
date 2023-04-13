import '../../exports.dart';
import 'package:intl/intl.dart';

class CalendarAfternoon extends StatefulWidget {
  final user = FirebaseAuth.instance.currentUser;
  CalendarAfternoon({Key? key}) : super(key: key);

  @override
  State<CalendarAfternoon> createState() => _CalendarAfternoonState();
}

class _CalendarAfternoonState extends State<CalendarAfternoon> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _eliminarCitasAntiguas(); // Añade esta línea para eliminar las citas antiguas al inicializar el widget
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
  }

  Future<void> _eliminarCitasAntiguas() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final DateTime now = DateTime.now();
    final DateTime startOfToday = DateTime(now.year, now.month, now.day);

    final QuerySnapshot snapshot = await _firestore
        .collection('citas')
        .where('Fecha', isLessThan: startOfToday)
        .get();

    for (final doc in snapshot.docs) {
      await _firestore.collection('citas').doc(doc.id).delete();
    }
  }

  Future<bool> _isDaySelectable(DateTime day) async {
    if (day.isBefore(DateTime.now()) ||
        day.weekday == DateTime.saturday ||
        day.weekday == DateTime.sunday) {
      return false;
    }
    return !(await _allCitasOcupadas(day));
  }

  Future<bool> _allCitasOcupadas(DateTime date) async {
    final List<String> citasOcupadas = await _getCitasOcupadas(date);
    final List<String> todasCitas = _getCitas(date, citasOcupadas);
    return citasOcupadas.length == todasCitas.length;
  }

  Future<QuerySnapshot<Object?>> getUserDataFuture() {
    return FirebaseFirestore.instance
        .collection('usuarios')
        .where('Email', isEqualTo: widget.user?.email)
        .get();
  }

  Future<String?> getClienteUid() async {
    QuerySnapshot<Object?> userDataQuery = await getUserDataFuture();

    if (userDataQuery.docs.isNotEmpty) {
      return userDataQuery.docs.first.id;
    } else {
      // Manejar el caso cuando no se encuentra el documento
      return null;
    }
  }

  Future<void> _agregarCita(String cita) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    String? clienteUid = await getClienteUid();

    if (clienteUid != null) {
      await _firestore
          .collection('citas')
          .add({'Fecha': DateTime.parse(cita), 'Cliente': clienteUid});
    } else {
      // Manejar el caso cuando no se encuentra el UID del cliente
    }
  }

  Future<List<String>> _getCitasOcupadas(DateTime date) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    final QuerySnapshot snapshot = await _firestore
        .collection('citas')
        .where('Fecha',
            isGreaterThanOrEqualTo:
                DateTime(date.year, date.month, date.day, 0, 0, 0))
        .where('Fecha',
            isLessThan: DateTime(date.year, date.month, date.day, 23, 59, 59))
        .get();

    return snapshot.docs.map((doc) {
      final DateTime citaTime = doc['Fecha'].toDate();
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(citaTime);
    }).toList();
  }

  void _showCitasList(DateTime date) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FutureBuilder<List<String>>(
          future: _getCitasOcupadas(date),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final _citasOcupadas = snapshot.data!;

            return DraggableScrollableSheet(
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return ListView.builder(
                  controller: scrollController,
                  itemCount: _getCitas(date, _citasOcupadas).length,
                  itemBuilder: (BuildContext context, int index) {
                    String cita = _getCitas(date, _citasOcupadas)[index];
                    bool ocupada = _citasOcupadas.contains(cita);

                    return ListTile(
                      title: Text(cita),
                      trailing: Icon(
                        ocupada ? Icons.close : Icons.check,
                        color: ocupada ? Colors.red : Colors.green,
                      ),
                      onTap: () async {
                        if (!ocupada) {
                          // Muestra un diálogo para confirmar la cita
                          bool? confirmed = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirmar cita'),
                                content: Text(
                                    '¿Desea reservar la cita para las ${DateFormat('HH:mm').format(DateTime.parse(cita))}?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text('Confirmar'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirmed == true) {
                            // Agregar la cita ocupada a Firestore
                            await _agregarCita(cita);
                            // Actualizar la lista de citas ocupadas y cerrar el modal
                            setState(() {
                              _citasOcupadas.add(cita);
                            });
                            Navigator.of(context).pop();
                          }
                        }
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  List<String> _getCitas(DateTime date, List<String> citasOcupadas) {
    final List<String> citas = [];

    for (int i = 16; i < 20; i++) {
      DateTime citaTime = DateTime(date.year, date.month, date.day, i);
      String hora = DateFormat('yyyy-MM-dd HH:mm:ss').format(citaTime);
      citas.add(hora);
    }

    return citas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: TableCalendar(
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
        onDaySelected: (selectedDay, focusedDay) async {
          if (await _isDaySelectable(selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = DateTime(selectedDay.year, selectedDay.month, 1);
            });

            _showCitasList(selectedDay);
          }
        },
        calendarStyle: const CalendarStyle(
          outsideDaysVisible: false,
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, events) {
            return FutureBuilder<bool>(
              future: _allCitasOcupadas(day),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                bool todasCitasOcupadas = snapshot.data!;

                if (day.isBefore(DateTime.now()) ||
                    todasCitasOcupadas ||
                    day.weekday == DateTime.saturday ||
                    day.weekday == DateTime.sunday) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                    ),
                    child: Center(
                      child: Text(day.day.toString(),
                          style: TextStyle(color: Colors.grey[500])),
                    ),
                  );
                }
                return Stack(
                  children: [
                    Center(child: Text(day.day.toString())),
                    const Positioned(
                      top: 10.0,
                      right: 10.0,
                      child: SizedBox(
                        width: 8.0,
                        height: 8.0,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
