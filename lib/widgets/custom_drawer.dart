import '../exports.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final currentUser = FirebaseAuth.instance.currentUser; // Usuario actual
  CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  // Variables para saber si el usuario es trabajador o jefe
  bool isWorker = false;
  bool isBoss = false;
  String documentID = "";

  // Instancias de las clases que nos permiten verificar si el usuario es jefe o trabajador
  late UserIsBoss userIsBoss;
  late UserIsWorker userIsWorker;
  late UserDocumentID userDocumentID;

  @override
  void initState() {
    super.initState();
// Inicialización de la instancia de UserDocumentID y obtención del documentID
    if (widget.currentUser != null) {
      userDocumentID = UserDocumentID(widget.currentUser!.email);
      userDocumentID.getUserDocumentID().then((_) {
        setState(() {
          documentID = userDocumentID.documentID;
        });
      });
    }

    // Inicialización de la instancia de UserIsBoss y obtención del valor isBoss
    userIsBoss = UserIsBoss(widget.currentUser);
    userIsBoss.getUser().then((_) {
      setState(() {
        isBoss = userIsBoss.isBoss;
      });
    });
    // Inicialización de la instancia de UserIsWorker y obtención del valor isWorker
    userIsWorker = UserIsWorker(widget.currentUser);
    userIsWorker.getUser().then((_) {
      setState(() {
        isWorker = userIsWorker.isWorker;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: myColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            DrawerHeader(
              child: InkWell(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 60.0, bottom: 60),
                  child: Transform.scale(
                    scale: 7,
                    child: Image.asset(
                      'lib/images/logo.png',
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 21.0, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        widget.currentUser == null
                            ? "Usuario invitado"
                            : "${widget.currentUser!.email}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        maxLines: 1,
                        minFontSize: 10,
                        maxFontSize: 18,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Divider(color: Colors.grey[100]),
            ),
            if (widget.currentUser != null)
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ListTile(
                  leading: const Icon(Icons.settings, color: Colors.white),
                  title: const Text(
                    "Mi Perfil",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PerfilPage(userEmail: widget.currentUser?.email)),
                    );
                  },
                ),
              ),
            if (widget.currentUser != null && isWorker)
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ListTile(
                  leading: const Icon(
                    Icons.edit_calendar,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Mi Calendario',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CalendarWorker(workerUid: documentID);
                    }));
                  },
                ),
              ),
            if (widget.currentUser != null)
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ListTile(
                  leading: const Icon(
                    Icons.calendar_month,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Pedir Cita',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CalendarioCitasPage(),
                      ),
                    );
                  },
                ),
              ),
            if (widget.currentUser != null && isBoss)
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ListTile(
                  leading: const Icon(
                    Icons.group,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Trabajadores',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ListWorkers(user: widget.currentUser)),
                    );
                  },
                ),
              ),
            if (widget.currentUser != null && isBoss)
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ListTile(
                  leading: const Icon(
                    Icons.book,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Reservas',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListBookings()),
                    );
                  },
                ),
              ),
          ]),
          if (widget.currentUser != null)
            Center(
              child: Column(
                children: [
                  const CircleIconsWidget(),
                  Padding(
                    padding: const EdgeInsets.only(left: 60.0, bottom: 25),
                    child: ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Cerrar sesión',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () async {
                        try {
                          context.read<AuthenticationService>().signOut();

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AuthPage()),
                          );
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Error al cerrar sesión'),
                              content: const Text(
                                  'Se produjo un error al intentar cerrar sesión. Por favor, inténtelo de nuevo más tarde.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Aceptar'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          if (widget.currentUser == null)
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 25),
              child: Column(
                children: [
                  const CircleIconsWidget(),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    title: const AutoSizeText(
                      'Iniciar Sesión / Crear Cuenta',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      maxLines: 1,
                    ),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AuthPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
