import '../exports.dart';

// Clase HomePage que extiende StatefulWidget
class HomePage extends StatefulWidget {
  // Constructor HomePage
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Método build() que construye la estructura de la página principal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Barra de navegación personalizada
        appBar: const CustomAppBar(
          showBackArrow: false,
        ),
        // Cajón lateral personalizado
        endDrawer: CustomDrawer(),
        // Cuerpo de la página principal
        body: SingleChildScrollView(
          child: Column(children: [
            const Padding(
              padding: EdgeInsets.only(top: 40.0, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Fila de Iconos sobre los servicios que se realizan
                  IconsHome(
                    iconURL: 'lib/images/servicios.png',
                    text: 'Servicios',
                  ),
                  IconsHome(
                    iconURL: 'lib/images/mantenimientos.png',
                    text: 'Mantenimientos',
                  ),
                  IconsHome(
                    iconURL: 'lib/images/instalaciones.png',
                    text: 'Instalaciones',
                  )
                ],
              ),
            ),
            JobsCardsRow(),
            ProductsCardColumn(),

          ]),
        ));
  }
}
