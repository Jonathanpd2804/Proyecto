import '../exports.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackArrow; // Si se quiere mostrar las flecha de retroceso
  const CustomAppBar({super.key, required this.showBackArrow});

  // Tamaño preferido de la AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: myColor,
      
      // Botón de retroceso para volver a la pantalla anterior
      leading: showBackArrow
    ? GestureDetector(
        child: const Icon(Icons.arrow_back),
        onTap: () {
          Navigator.pop(context);
        })
    : Container(),

      actions: [
        // Logo y nombre de la aplicación en la AppBar
        Padding(
          padding: const EdgeInsets.only(right: 120.0),
          child: Row(
            children: [
              Image.asset(
                'lib/images/logo.png',
              ),
              const SizedBox(width: 20),
              const Text(
                'David Perez',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        
        // Icono de persona que abre el drawer
        IconButton(
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
          icon: const Icon(Icons.person),
        ),
      ],
    );
  }
}
