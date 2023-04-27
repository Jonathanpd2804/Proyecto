import 'package:david_perez/widgets/bookings/show_booking.dart';

import '../../exports.dart';
import 'package:intl/intl.dart';

class BookingsListView extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;
  final String? clienteEmail;

  BookingsListView({
    Key? key,
    required this.clienteEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Query bookingsQuery = FirebaseFirestore.instance
        .collection('reservas')
        .where('clienteEmail', isEqualTo: clienteEmail);

    return StreamBuilder<QuerySnapshot>(
      stream: bookingsQuery.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(
              child: Text('Error al cargar la lista de reservas'));
        }

        final bookings = snapshot.data!.docs;

        if (bookings.isEmpty) {
          return Center(
            child: Text(currentUser!.email == clienteEmail
                ? 'No tienes ninguna reserva'
                : 'No tiene ninguna reserva'),
          );
        }

        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return ListTile(
              title: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          DateFormat('dd/MM/yyyy - hh:mm:ss a').format(booking[
                                  'fechaReserva']
                              .toDate()), // Formatea la fecha y hora como un String
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: GestureDetector(
                          child: const Icon(Icons.delete),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DeleteQuoteDialog(quote: booking);
                              },
                            );
                          },
                        ),
                      ),
                      GestureDetector(
                        child: const Icon(Icons.remove_red_eye),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ShowBookingDialog(booking: booking);
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
