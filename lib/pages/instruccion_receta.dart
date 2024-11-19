import 'package:flutter/material.dart';
import 'package:flutterproyecto/pages/colores.dart';
import 'package:flutterproyecto/services/firebase_service.dart';

class InstruccionReceta extends StatefulWidget {
  const InstruccionReceta(
      {super.key,
      required this.correo,
      required this.nombre,
      required this.instrucciones});

  final String correo;
  final String nombre;
  final String instrucciones;
  @override
  State<InstruccionReceta> createState() => _InstruccionRecetaState();
}

class _InstruccionRecetaState extends State<InstruccionReceta> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseService().RecetaInstruccion(
            widget.correo, widget.nombre, widget.instrucciones),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var receta = snapshot.data.docs[0];
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(ColorPrimario),
              title: ListTile(
                title: Text(receta['nombre']),
                subtitle: Text(receta['autor']),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(receta['categoria']),
                  Text('foto'),
                  Text(receta['instrucciones'])
                ],
              ),
            ),
          );
        });
  }
}