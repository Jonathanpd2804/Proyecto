import 'exports.dart';

void main() async {
  // Inicialización de Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configuración de la orientación de la pantalla
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Ejecución de la aplicación
  runApp(const MyApp());
}

// Color personalizado para la aplicación
const MaterialColor myColor = MaterialColor(
  0XFFE65100,
  <int, Color>{
    50: Color(0xFFFFF3E0),
    100: Color(0xFFFFE0B2),
    200: Color(0xFFFFCC80),
    300: Color(0xFFFFB74D),
    400: Color(0xFFFFA726),
    500: Color(0XFFE65100),
    600: Color(0xFFF4511E),
    700: Color(0xFFE64A19),
    800: Color(0xFFD84315),
    900: Color(0xFFBF360C),
  },
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: myColor, // Color personalizado para la aplicación
      debugShowCheckedModeBanner: false, // Desactivación del banner de depuración
      home: HomePage(),
    );
  }
}
