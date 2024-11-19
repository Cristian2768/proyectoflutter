import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterproyecto/pages/colores.dart';
import 'package:flutterproyecto/pages/instruccion_receta.dart';
import 'package:flutterproyecto/pages/login_page.dart';
import 'package:flutterproyecto/services/auth_service.dart';
import 'package:flutterproyecto/services/firebase_service.dart';
import 'package:flutterproyecto/util/snackbar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService().usuarioActual(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(ColorPrimario),
              title: ListTile(
                title: Text('Bienvenido: ' + snapshot.data!.displayName!),
                trailing: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: IconButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Snackbar().ShowSnackbar('Sesion cerrada', context);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                            (Route<dynamic> route) => false);
                      },
                      icon: Icon(MdiIcons.logout)),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Color(ColorPrimario),
              foregroundColor: Colors.white,
              child: Icon(MdiIcons.plus),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            body: StreamBuilder(
              stream: FirebaseService().recetas(),
              builder: (BuildContext context, AsyncSnapshot snapshotRecetas) {
                if (!snapshotRecetas.hasData ||
                    snapshotRecetas.connectionState ==
                        ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshotRecetas.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    var receta = snapshotRecetas.data!.docs[index];
                    if (receta['correo'] == snapshot.data!.email!) {
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {},
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
                                        instrucciones:
                                            receta['instrucciones'])));
                          },
                          child: ListTile(
                            //colocar foto aqui
                            leading: Text('foto'),
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
                    }
                    return ElevatedButton(
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
                                    instrucciones: receta['instrucciones'])));
                      },
                      child: ListTile(
                        //colocar foto aqui
                        leading: Text('foto'),
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
                    );
                  },
                );
              },
            ),
          );
        });
  }
}
