import '../../exports.dart';

class CalendarioCitasPage extends StatefulWidget {
  const CalendarioCitasPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CalendarioCitasPageState createState() => _CalendarioCitasPageState();
}

class _CalendarioCitasPageState extends State<CalendarioCitasPage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          showBackArrow: true,
        ),
        endDrawer: CustomDrawer(),
        body: SingleChildScrollView(
          child: Column(children: [
            const Padding(
              padding: EdgeInsets.only(top: 30.0, bottom: 30),
              child: Text(
                "Turno de Mañana:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SingleChildScrollView(
                child: SizedBox(height: 400, child: CalendarioManana())),
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Turno de Tarde:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SingleChildScrollView(
                child: SizedBox(height: 400, child: CalendarioTarde())),
          ]),
        ));
  }
}
