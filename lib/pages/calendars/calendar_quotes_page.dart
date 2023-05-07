import '../../exports.dart';
import 'package:intl/intl.dart';

class CalendarQuotesPage extends StatefulWidget {
  final user = FirebaseAuth.instance.currentUser;
  CalendarQuotesPage({Key? key}) : super(key: key);

  @override
  State<CalendarQuotesPage> createState() => _CalendarQuotesPageState();
}

class _CalendarQuotesPageState extends State<CalendarQuotesPage> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  CalendarService calendarService = CalendarService();

  @override
  void initState() {
    super.initState();
    calendarService
        .deleteOldQuotes(); // Eliminar las citas antiguas al inicializar el widget
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
  }

  bool _isDaySelectable(DateTime day, List<String> quotesBusy) {
    if (day.isBefore(DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)) ||
        day.weekday == DateTime.saturday ||
        day.weekday == DateTime.sunday) {
      return false;
    }
    final List<String> allQuotes = _getQuotes(day, quotesBusy);
    return quotesBusy.length != allQuotes.length;
  }

  Future<bool> _allQuotesBusy(DateTime date) async {
    final List<String> quotesBusy = await _getQuotesBusy(date);
    final List<String> allQuotes = _getQuotes(date, quotesBusy);
    return quotesBusy.length == allQuotes.length;
  }

  Future<void> _addQuote(String quote, String direccion) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    String clientUid = await calendarService.getClientUid();

    DateTime quoteDateTime = DateTime.parse(quote);
    String turn = "";

    if (quoteDateTime.hour >= 8 && quoteDateTime.hour < 17) {
      turn = "Mañana";
    } else if (quoteDateTime.hour >= 17 && quoteDateTime.hour < 20) {
      turn = "Tarde";
    }

    final quoteRef = await firestore.collection('citas').add({
      'Fecha': quoteDateTime,
      'Cliente': clientUid,
      'Turno': turn,
      'Dirección': direccion,
      'Realizada': false
    });

    //Obtener el trabajador con el turno de la cita
    String workerID = await calendarService.getWorkerUid(turn);

    await firestore.collection('tareas').add({
      'Fecha': quoteDateTime,
      'Trabajador': workerID,
      'Realizada': false,
      'Asignada': true,
      'Dirección': direccion,
      'Importante': true,
      'Título': "Medición",
      'IdCita': quoteRef.id,
    });
  }

  Future<List<String>> _getQuotesBusy(DateTime date) async {
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
      final DateTime quoteTime = doc['Fecha'].toDate();
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(quoteTime);
    }).toList();
  }

  void _showQuotesList(DateTime date) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FutureBuilder<List<String>>(
          future: _getQuotesBusy(date),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final quotesBusy = snapshot.data!;

            return DraggableScrollableSheet(
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return ListView.builder(
                  controller: scrollController,
                  itemCount: _getQuotes(date, quotesBusy).length,
                  itemBuilder: (BuildContext context, int index) {
                    String quote = _getQuotes(date, quotesBusy)[index];
                    bool busy = quotesBusy.contains(quote);

                    return ListTile(
                      title: Text(quote),
                      trailing: Icon(
                        busy ? Icons.close : Icons.check,
                        color: busy ? Colors.red : Colors.green,
                      ),
                      onTap: () async {
                        if (!busy) {
                          String? address;
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
                                        '¿Desea reservar la cita para las ${DateFormat('HH:mm').format(DateTime.parse(quote))}?'),
                                    const SizedBox(height: 8),
                                    TextField(
                                      onChanged: (value) => address = value,
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

                          if (confirmed == true && address != null) {
                            // Agregar la cita ocupada a Firestore con la dirección
                            await _addQuote(quote, address!);
                            // Actualizar la lista de citas ocupadas
                            setState(() {
                              quotesBusy.add(quote);
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

  List<String> _getQuotes(DateTime date, List<String> quotesBusy) {
    final List<String> quotes = [];

    for (int i = 8; i < 21; i++) {
      DateTime quoteTime = DateTime(date.year, date.month, date.day, i);
      String hour = DateFormat('yyyy-MM-dd HH:mm:ss').format(quoteTime);
      quotes.add(hour);
    }

    return quotes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showBackArrow: true),
      endDrawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey, // color del borde
                    width: 2.0, // ancho del borde
                  ),
                  borderRadius: BorderRadius.circular(10.0)), // radio de borde
              child: Padding(
                padding: const EdgeInsets.all(10.0),
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
                    // Obtén las citas ocupadas en el día seleccionado
                    _getQuotesBusy(selectedDay).then((quotesBusy) {
                      // Verifica si el día es seleccionable antes de cambiar el estado y mostrar la lista de citas
                      if (_isDaySelectable(selectedDay, quotesBusy)) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay =
                              DateTime(selectedDay.year, selectedDay.month, 1);
                        });

                        _showQuotesList(selectedDay);
                      }
                    });
                  },
                  calendarStyle: const CalendarStyle(
                    outsideDaysVisible: false,
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, events) {
                      return FutureBuilder<bool>(
                        future: _allQuotesBusy(day),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          bool allQuotesBusy = snapshot.data!;

                          if (day.isBefore(DateTime.now()) ||
                              allQuotesBusy ||
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
