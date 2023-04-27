// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, use_build_context_synchronously

import '../../exports.dart';

class ProductCardWidget extends StatefulWidget {
  final String productID;
  final product;

  const ProductCardWidget(
      {Key? key, required this.product, required this.productID})
      : super(key: key);

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  final currentUser = FirebaseAuth.instance.currentUser;
  // Usuario actual
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Stream<QuerySnapshot> getDocsStream() {
    return FirebaseFirestore.instance
        .collection('usuarios')
        .where('Email', isEqualTo: currentUser?.email)
        .snapshots();
  }

  Future<void> sendEmail(
      BuildContext context, String userName, String reservaId) async {
    // Configura las credenciales del servidor SMTP
    String username = 'jonathanpd280403@gmail.com';
    String password = 'rtrtuhyqxiddefzh';

    // Usa el servidor SMTP de Gmail
    final smtpServer = gmail(username, password);

    // Crea el mensaje
    final message = Message()
      ..from = Address(username, userName)
      // ..recipients.add('${currentUser?.email}')
      ..recipients.add('jonathanpd280403@gmail.com')
      ..subject = 'Reserva'
      ..html = '''
<!DOCTYPE html>
<html>
<head>
  <style>
    h1 {
      font-size: 24px;
      font-weight: bold;
      color: #444;
    }
    p {
      font-size: 16px;
      color: #666;
    }
  </style>
</head>
<body>
  <h1>Confirmación de reserva: $reservaId</h1>
  <p>Estimado cliente,</p>
  <p>Nos complace informarle que su reserva ha sido guardada con éxito. Para mantener su reserva activa, debe realizar un abono del 50% del precio total dentro de los próximos 3 días. De no realizar el abono en este plazo, su reserva será cancelada automáticamente.</p>
  <p>Por favor, realice el abono en la siguiente cuenta bancaria:</p>
  <p><strong>Número de cuenta:</strong> [Número de cuenta]</p>
  <p>Una vez realizado el abono, por favor envíenos un correo electrónico con el comprobante de pago para confirmar su reserva. También puede enviar el justificante de pago por WhatsApp. Para hacerlo, simplemente puede buscar el icono de WhatsApp en el menú de la aplicación y selecciónelo para abrir una conversación con nosotros donde envíe el numero de reserva y el justificante de el pago.</p>
  <p>El producto reservado es: ${widget.product["Título"]}</p>
  <p>Gracias por elegir nuestros servicios. Si tiene alguna pregunta, no dude en ponerse en contacto con nosotros.</p>
  <p>Atentamente,</p>
  <p>David Pérez</p>
</body>
</html>

''';

    try {
      // Envía el correo electrónico
      final sendReport = await send(message, smtpServer);
      print('Mensaje enviado: $sendReport');
      showSendDialog(_scaffoldKey);
    } catch (e) {
      showErrorDialog(context);
    }
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar reserva'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Estás seguro de que deseas reservar este producto?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Reservar'),
              onPressed: () async {
                Navigator.of(context).pop();
                String userName = '';
                await for (var snapshot in getDocsStream()) {
                  final userDoc = snapshot.docs.first;
                  userName = userDoc['Nombre'];
                  break;
                }

                final reserva = {
                  'clienteEmail': currentUser?.email,
                  'productoId': widget.productID,
                  'fechaReserva': Timestamp.now(),
                  'pagado': false,
                };

                final reservaRef = await FirebaseFirestore.instance
                    .collection('reservas')
                    .add(reserva);

                final reservaId = reservaRef.id;

                // Actualiza la cantidad disponible del producto en la base de datos
                final productoRef = FirebaseFirestore.instance
                    .collection('productos')
                    .doc(widget.productID);

                FirebaseFirestore.instance.runTransaction((transaction) async {
                  final producto = await transaction.get(productoRef);
                  final cantidadActual = int.parse(producto['Cantidad']);

                  const cantidadReservada = 1; // Cantidad a reservar

                  if (cantidadActual >= cantidadReservada) {
                    final nuevaCantidad = cantidadActual - cantidadReservada;
                    transaction.update(
                        productoRef, {'Cantidad': nuevaCantidad.toString()});
                  } else {
                    throw 'No hay suficiente cantidad disponible';
                  }
                }).then((value) {
                  sendEmail(context, userName, reservaId);
                }).catchError((error) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Error'),
                      content: Text(error.toString()),
                    ),
                  );
                });
              },
            ),
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: FlipCard(
        fill: Fill.fillBack,
        direction: FlipDirection.HORIZONTAL,
        side: CardSide.FRONT,
        front: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 8,
            child: Column(children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Stack(
                  children: [
                    Image.network(
                      widget.product['ImagenURL'],
                      fit: BoxFit.cover,
                      width: 200,
                      height: 225,
                    ),
                    // Image.asset(
                    //   'lib/images/logo.png',
                    // ),
                    // Container(
                    //   width: 200,
                    //   height: 225,
                    //   color: Colors.black.withOpacity(0.5),
                    //   child: const Center(
                    //     child: Text(
                    //       'Error al cargar la imagen',
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              const Padding(
                  padding: EdgeInsets.all(18.0), child: Icon(Icons.touch_app))
            ])),
        back: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 8,
            child: Column(children: [
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Scrollbar(
                          child: SizedBox(
                            height: 45, // Altura del contenedor
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: SingleChildScrollView(
                                child: Text(
                                  widget.product["Título"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Divider(thickness: 1, color: Colors.black87),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Scrollbar(
                              child: SizedBox(
                                height: 82, // Altura del contenedor
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: SingleChildScrollView(
                                    child: Text(
                                      widget.product["Descripción"],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Divider(thickness: 1, color: Colors.black87),
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Scrollbar(
                              child: SizedBox(
                                height: 15, // Altura del contenedor
                                child: Text(
                                  "${widget.product["Precio"].toString()} €",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            // Cambiar el color de fondo del botón

                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(myColor),
                                ),
                                onPressed: () {
                                  if (currentUser == null) {
                                    // Muestra un mensaje indicando que el usuario debe iniciar sesión
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Debes iniciar sesión para reservar'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  } else {
                                    if (widget.product["Cantidad"] == "0") {
                                      // Muestra un mensaje indicando que el producto está agotado
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Producto agotado'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    } else {
                                      // Muestra el cuadro de diálogo de confirmación
                                      _showConfirmationDialog(context);
                                    }
                                  }
                                },
                                child: Text(
                                  widget.product["Cantidad"] != "0"
                                      ? "Reservar"
                                      : "Agotado",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
              const Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Center(child: Icon(Icons.touch_app)),
              )
            ])),
      ),
    );
  }
}

void showErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: const Text('No se pudo enviar el correo electrónico'),
        actions: <Widget>[
          TextButton(
            child: const Text('Aceptar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showSendDialog(GlobalKey<ScaffoldState> scaffoldKey) {
  showDialog(
    context: scaffoldKey.currentContext!, // Utiliza el contexto del GlobalKey
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enviado'),
        content: const Text('Se le ha enviado un email a su correo'),
        actions: <Widget>[
          TextButton(
            child: const Text('Aceptar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
