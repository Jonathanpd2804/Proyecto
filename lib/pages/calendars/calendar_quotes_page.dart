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
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30),
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.only(top: 30.0, bottom: 30),
              ),
              SingleChildScrollView(
                  child: SizedBox(height: 400, child: CalendarAskQuotes())),
            ]),
          ),
        ));
  }
}
