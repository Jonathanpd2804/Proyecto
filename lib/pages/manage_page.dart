// ignore_for_file: deprecated_member_use


import '../exports.dart';

class ManagePage extends StatefulWidget {
  ManagePage({super.key});
  final currentUser = FirebaseAuth.instance.currentUser; // Usuario actual

  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showBackArrow: true),
      endDrawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(top: 150.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            _buildCard('Trabajadores', Icons.person,
                ListWorkers(user: widget.currentUser)),
            _buildCard('Reservas', Icons.event, const ListBookings()),
            _buildCard('Productos', Icons.shopping_cart, const ListProducts()),
            _buildCard('Trabajos', Icons.work, const ListJobs()),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData iconData, route) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => route),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(iconData, size: 80.0),
            const SizedBox(height: 16.0),
            Text(title, style: Theme.of(context).textTheme.headline6),
          ],
        ),
      ),
    );
  }
}
