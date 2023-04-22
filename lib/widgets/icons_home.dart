import '../exports.dart';

class IconsHome extends StatefulWidget {
  final String iconURL;
  final String text;
  const IconsHome({Key? key, required this.iconURL, required this.text}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _IconsHomeState createState() => _IconsHomeState();
}

class _IconsHomeState extends State<IconsHome> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const JobForm(),
          ),
        );
      },
      child: Column(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Image.asset(
              widget.iconURL,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
              height: 5), // Agrega espacio entre la imagen y el texto
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
