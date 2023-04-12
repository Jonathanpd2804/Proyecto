// import '../../../exports.dart';

// class BorrarCitasAntiguas extends StatefulWidget {
//   const BorrarCitasAntiguas({ Key? key }) : super(key: key);

//   @override
//   _BorrarCitasAntiguasState createState() => _BorrarCitasAntiguasState();
// }

// class _BorrarCitasAntiguasState extends State<BorrarCitasAntiguas> {
//   Future<void> _eliminarCitasAntiguas() async {
//     final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//     final DateTime now = DateTime.now();
//     final DateTime startOfToday = DateTime(now.year, now.month, now.day);

//     final QuerySnapshot snapshot = await _firestore
//         .collection('citas')
//         .where('Fecha', isLessThan: startOfToday)
//         .get();

//     for (final doc in snapshot.docs) {
//       await _firestore.collection('citas').doc(doc.id).delete();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Call the function here or in any other appropriate method
    
//     return _eliminarCitasAntiguas();; // Replace this with your actual widget
//   }
// }
