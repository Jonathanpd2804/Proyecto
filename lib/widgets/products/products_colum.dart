
// ignore_for_file: sized_box_for_whitespace

import '../../exports.dart';

class ProductsCardColumn extends StatefulWidget {
  
  final currentUser = FirebaseAuth.instance.currentUser; // Usuario actual

  ProductsCardColumn({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsCardColumn> createState() => _ProductsCardColumnState();
}

class _ProductsCardColumnState extends State<ProductsCardColumn> {
  bool isBoss = false;

  late UserIsBoss userIsBoss;

  @override
  void initState() {
    super.initState();
    // Inicialización de la instancia de UserIsBoss y obtención del valor isBoss
    userIsBoss = UserIsBoss(widget.currentUser);
    userIsBoss.getUser().then((_) {
      setState(() {
        isBoss = userIsBoss.isBoss;
      });
    });
  }

  final FirebaseFirestore database = FirebaseFirestore.instance;

  Stream<QuerySnapshot> fetchProductsStream() {
    return database.collection('productos').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50.0, bottom: 25),
          // Lista vertical de productos
          child: StreamBuilder(
            // Stream de QuerySnapshot de la colección "productos"
            stream: fetchProductsStream(),
            // Constructor de la lista vertical de productos
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              // Si el estado de conexión es de espera, muestra un indicador de progreso
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // Si hay un error al cargar los productos, muestra un mensaje de error
              if (snapshot.hasError) {
                return const Center(
                    child: Text('Error al cargar los productos'));
              }

              // Lista de productos
              List<DocumentSnapshot> products = snapshot.data!.docs;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: products.map((product) {
                  final productData = product.data() as Map<String, dynamic>;
                  final productId = product.id;
                  return Container(
                    width: MediaQuery.of(context).size.width / 2 - 15,
                    height: 300,
                    child:
                        ProductCardWidget(id: productId, product: productData),
                  );
                }).toList(),
              );
            },
          ),
        ),
        
      ],
    );
  }
}
