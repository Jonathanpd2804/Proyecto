import '../../exports.dart';
import 'package:intl/intl.dart';

class CalendarAskQuotes extends StatefulWidget {
  final user = FirebaseAuth.instance.currentUser;
  CalendarAskQuotes({Key? key}) : super(key: key);

  @override
  State<CalendarAskQuotes> createState() => _CalendarAskQuotesState();
}

class _CalendarAskQuotesState extends State<CalendarAskQuotes> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CalendarService calendarioService = CalendarService();

  @override
  void initState() {
    super.initState();
    calendarioService
        .eliminarCitasAntiguas(); // Eliminar las citas antiguas al inicializar el widget
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
  }

  bool _isDaySelectable(DateTime day, List<String> citasOcupadas) {
    if (day.isBefore(DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)) ||
        day.weekday == DateTime.saturday ||
        day.weekday == DateTime.sunday) {
      return false;
    }
    final List<String> todasCitas = _getCitas(day, citasOcupadas);
    return citasOcupadas.length != todasCitas.length;
  }

  Future<bool> _allCitasOcupadas(DateTime date) async {
    final List<String> citasOcupadas = await _getCitasOcupadas(date);
    final List<String> todasCitas = _getCitas(date, citasOcupadas);
    return citasOcupadas.length == todasCitas.length;
  }

  Future<void> _agregarCita(String cita, String direccion) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    String clienteUid = await calendarioService.getClienteUid();

    if (clienteUid != null) {
      DateTime citaDateTime = DateTime.parse(cita);
      String turn = "";

      if (citaDateTime.hour >= 8 && citaDateTime.hour < 17) {
        turn = "Mañana";
      } else if (citaDateTime.hour >= 17 && citaDateTime.hour < 20) {
        turn = "Tarde";
      }

      await firestore.collection('citas').add({
        'Fecha': citaDateTime,
        'Cliente': clienteUid,
        'Turno': turn,
        'Dirección': direccion,
        'Realizada': false
      });

      //Agregarla a tareas de el trabajador que tenga ese turno

      //Obtener el trabajador con el turno de la cita
      String workerID = await calendarioService.getWorkerUid(turn);

      await firestore.collection('tareas').add({
        'Fecha': citaDateTime,
        'Trabajador': workerID,
        'Realizada': false,
        'Asignada': true,
        'Descripción': "Medición en: $direccion",
        'Importante': true,
        'Título': "Medición"
      });
    }
  }

  Future<List<String>> _getCitasOcupadas(DateTime date) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final QuerySnapshot snapshot = await firestore
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

            final citasOcupadas = snapshot.data!;

            return DraggableScrollableSheet(
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return ListView.builder(
                  controller: scrollController,
                  itemCount: _getCitas(date, citasOcupadas).length,
                  itemBuilder: (BuildContext context, int index) {
                    String cita = _getCitas(date, citasOcupadas)[index];
                    bool ocupada = citasOcupadas.contains(cita);

                    return ListTile(
                      title: Text(cita),
                      trailing: Icon(
                        ocupada ? Icons.close : Icons.check,
                        color: ocupada ? Colors.red : Colors.green,
                      ),
                      onTap: () async {
                        if (!ocupada) {
                          String? direccion;
                          // Muestra un diálogo para confirmar la cita y pedir la dirección
                          bool? confirmed = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirmar cita y dirección'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        '¿Desea reservar la cita para las ${DateFormat('HH:mm').format(DateTime.parse(cita))}?'),
                                    SizedBox(height: 8),
                                    TextField(
                                      onChanged: (value) => direccion = value,
                                      decoration: const InputDecoration(
                                          hintText: "Dirección"),
                                    ),
                                  ],
                                ),
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

                          if (confirmed == true && direccion != null) {
                            // Agregar la cita ocupada a Firestore con la dirección
                            await _agregarCita(cita, direccion!);
                            // Actualizar la lista de citas ocupadas
                            setState(() {
                              citasOcupadas.add(cita);
                            });
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

    for (int i = 8; i < 21; i++) {
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
        onDaySelected: (selectedDay, focusedDay) {
          // Obtén las citas ocupadas en el día seleccionado
          _getCitasOcupadas(selectedDay).then((citasOcupadas) {
            // Verifica si el día es seleccionable antes de cambiar el estado y mostrar la lista de citas
            if (_isDaySelectable(selectedDay, citasOcupadas)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = DateTime(selectedDay.year, selectedDay.month, 1);
              });

              _showCitasList(selectedDay);
            }
          });
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
