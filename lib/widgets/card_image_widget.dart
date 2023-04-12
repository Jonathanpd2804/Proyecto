import '../exports.dart';

class CardImageWidget extends StatelessWidget {
  final job;

  const CardImageWidget({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      fill: Fill
          .fillBack, 
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
              child: Image.network(job['Image']),
            ),
            const Padding(
                padding: EdgeInsets.all(18.0), child: Icon(Icons.ads_click))
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
                                job["Tittle"],
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
                                    job["Description"],
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
