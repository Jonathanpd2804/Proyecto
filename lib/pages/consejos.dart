import 'package:flutter/material.dart';

class ConsejosMantenimientoCarpinteria extends StatelessWidget {
  const ConsejosMantenimientoCarpinteria({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consejos de mantenimiento de carpintería'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConsejoMantenimientoCarpinteria(
                  icono: Icons.cleaning_services,
                  titulo: 'Limpieza regular',
                  descripcion:
                      'Limpia la carpintería regularmente con un paño suave y seco.',
                ),
                ConsejoMantenimientoCarpinteria(
                  icono: Icons.water_damage,
                  titulo: 'Protección contra la humedad',
                  descripcion:
                      'Protege la carpintería contra la humedad con un sellador o pintura adecuada.',
                ),
                ConsejoMantenimientoCarpinteria(
                  icono: Icons.build,
                  titulo: 'Mantenimiento preventivo',
                  descripcion:
                      'Inspecciona la carpintería regularmente para detectar signos de daño o desgaste.',
                ),
                ConsejoMantenimientoCarpinteria(
                  icono: Icons.wb_sunny_outlined,
                  titulo: 'Cuidado durante el clima extremo',
                  descripcion:
                      'Protege la carpintería durante el clima extremo cerrando ventanas y puertas adecuadamente.',
                ),
                ConsejoMantenimientoCarpinteria(
                  icono: Icons.handyman,
                  titulo: 'Mantenimiento profesional',
                  descripcion:
                      'Contrata a un profesional para que revise la carpintería y realice cualquier reparación necesaria.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConsejoMantenimientoCarpinteria extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String descripcion;

  const ConsejoMantenimientoCarpinteria({
    Key? key,
    required this.icono,
    required this.titulo,
    required this.descripcion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Icon(
            icono,
            size: 64.0,
            color: Colors.white,
          ),
          SizedBox(height: 16.0),
          Text(
            titulo,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            descripcion,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
