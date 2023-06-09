import '../../exports.dart';

class JobCardWidget extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final job;

  const JobCardWidget({Key? key, required this.job}) : super(key: key);

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
                  Image.network(
                    job['ImagenURL'],
                    fit: BoxFit.cover,
                    width: 150,
                    height: 185,
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
                padding: EdgeInsets.all(18.0), child: Icon(Icons.touch_app))
          ])),
    );
  }
}
