import '../exports.dart';

class CardImageWidget extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final job;

  const CardImageWidget({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlipCard(
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
                  // Image.network(
                  //   job['ImagenURL'],
                  //   fit: BoxFit.cover,
                  //   width: 150,
                  //   height: 150,
                  // ),
                  Image.asset(
                    'lib/images/logo.png',
                  ),
                  Container(
                    width: 150,
                    height: 150,
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: Text(
                        'Error al cargar la imagen',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
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
                                job["Título"],
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
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Scrollbar(
                            child: SizedBox(
                              height: 90, // Altura del contenedor
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: SingleChildScrollView(
                                  child: Text(
                                    job["Descripción"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                )),
            const Padding(
                padding: EdgeInsets.all(18.0), child: Icon(Icons.ads_click))
          ])),
    );
  }
}
