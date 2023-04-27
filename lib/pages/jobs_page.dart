import 'package:david_perez/widgets/jobs/edit_job.dart';
import 'package:david_perez/widgets/products/edit_product.dart';

import '../exports.dart';

class ListJobs extends StatelessWidget {
  const ListJobs({Key? key}) : super(key: key);

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
              child: const Text("Agregar Trabajo"),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('trabajos').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Error al cargar los datos');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final jobs = snapshot.data!.docs;

              if (jobs.isEmpty) {
                return const Center(child: Text('No hay trabajos'));
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: jobs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final job = jobs[index];
                    final jobID = job.id;
                    final String descriptionJob = job['Descripción'];
                    final String imageURLJob = job['ImagenURL'];
                    final String titleJob = job['Título'];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text('Trabajo: $titleJob'),
                            ),
                            ListTile(
                              title: Text('Descripción: $descriptionJob'),
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
                                        builder: (context) => EditJob(job: job),
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
                                        title: const Text('Borrar trabajo'),
                                        content: const Text(
                                            '¿Está seguro que desea borrar este trabajo?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection('trabajos')
                                                  .doc(jobID)
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
