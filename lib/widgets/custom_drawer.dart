
import '../exports.dart';

class CustomDrawer extends StatefulWidget {
  final user = FirebaseAuth.instance.currentUser;
  CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isWorker = false;
  bool isBoss = false;
  String documentID = "";
  late UserIsBoss userIsBoss;
  late UserIsWorker userIsWorker;

  @override
  void initState() {
    super.initState();
    userIsBoss = UserIsBoss(widget.user);
    userIsBoss.getUser().then((_) {
      setState(() {
        isBoss = userIsBoss.isBoss;
      });
    });
    userIsWorker = UserIsWorker(widget.user);
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
                        widget.user == null
                            ? "Usuario invitado"
                            : "${widget.user!.email}",
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
            if (widget.user != null)
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
                          builder: (context) => PerfilPage(
                                userEmail: widget.user?.email,
                              )),
                    );
                  },
                ),
              ),
            if (widget.user != null)
              Column(
                children: [
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
                          if (isWorker) {
                            return CalendarioTrabajador(
                                trabajadorUid: documentID);
                          } else {
                            return CalendarioCliente(clienteUid: documentID);
                          }
                        }));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Pedir Citas',
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
                ],
              ),
            if (isBoss)
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
                              ListaTrabajadores(user: widget.user)),
                    );
                  },
                ),
              ),
          ]),
          if (widget.user != null)
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
                  await FirebaseAuth.instance.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthPage()),
                  );
                },
              ),
            ),
          if (widget.user == null)
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 25),
              child: ListTile(
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
                    MaterialPageRoute(builder: (context) => const AuthPage()),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
