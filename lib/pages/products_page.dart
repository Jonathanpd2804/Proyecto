import 'package:david_perez/widgets/products/edit_product.dart';

import '../exports.dart';

class ListProducts extends StatelessWidget {
  const ListProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showBackArrow: true),
      endDrawer: CustomDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductForm(),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(myColor),
              ),
              child: const Text("Agregar Producto"),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('productos').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Error al cargar los datos');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final products = snapshot.data!.docs;

              if (products.isEmpty) {
                return const Center(child: Text('No hay productos'));
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    final product = products[index];
                    final productID = product.id;
                    final stockProduct = product['Cantidad'];
                    final String descriptionProduct = product['Descripción'];
                    final String priceProduct = product['Precio'];
                    final String titleProduct = product['Título'];
                    final String imageURL = product["ImagenURL"];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text('Producto: $titleProduct'),
                            ),
                            ListTile(
                              title: Text('Descripción: $descriptionProduct'),
                              subtitle: Text('Precio: $priceProduct €'),
                              trailing: Text(stockProduct != 0
                                  ? 'En Stock: $stockProduct'
                                  : 'Agotado'),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditProduct(product: product),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Editar',
                                    style: TextStyle(color: myColor),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Borrar producto'),
                                        content: const Text(
                                            '¿Está seguro que desea borrar este producto?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection('productos')
                                                  .doc(productID)
                                                  .delete();
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Borrar'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Borrar',
                                    style: TextStyle(color: myColor),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
