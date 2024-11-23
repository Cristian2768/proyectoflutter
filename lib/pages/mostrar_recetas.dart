import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterproyecto/pages/colores.dart';
import 'package:flutterproyecto/pages/instruccion_receta.dart';
import 'package:flutterproyecto/services/auth_service.dart';
import 'package:flutterproyecto/services/firebase_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MostrarRecetas extends StatefulWidget {
  const MostrarRecetas({super.key});

  @override
  State<MostrarRecetas> createState() => _MostrarRecetasState();
}

class _MostrarRecetasState extends State<MostrarRecetas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(ColorPrimario),
        title: Text("Tus recetas"),
      ),
      body: FutureBuilder(
        future: AuthService().usuarioActual(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return FutureBuilder(
            future: FirebaseService().recetasPropias(snapshot.data!.email),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var receta = snapshot.data.docs[index];
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            FirebaseService().borrarReceta(receta.id);
                            setState(() {});
                          },
                          icon: MdiIcons.delete,
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          label: 'Borrar',
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0))),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InstruccionReceta(
                              correo: receta['correo'],
                              nombre: receta['nombre'],
                              instrucciones: receta['instrucciones'],
                              id: receta.id,
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: FutureBuilder(
                          future:
                              FirebaseService().buscarFoto(receta['categoria']),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData ||
                                snapshot.connectionState ==
                                    ConnectionState.waiting) {
                              return Text("Cargando");
                            }
                            var categoria = snapshot.data!.docs[0];
                            return Image(
                              image: AssetImage(
                                  'assets/images/' + categoria['foto']),
                              width: 100,
                              height: 100,
                            );
                          },
                        ),
                        //titulo + autor
                        title: Column(
                          children: [
                            Text(receta['nombre']),
                            Text(
                              receta['autor'],
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(receta['categoria'])
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
