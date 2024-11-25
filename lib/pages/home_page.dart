import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterproyecto/pages/agregar_receta.dart';
import 'package:flutterproyecto/pages/colores.dart';
import 'package:flutterproyecto/pages/instruccion_receta.dart';
import 'package:flutterproyecto/pages/login_page.dart';
import 'package:flutterproyecto/pages/mostrar_recetas.dart';
import 'package:flutterproyecto/services/auth_service.dart';
import 'package:flutterproyecto/services/firebase_service.dart';
import 'package:flutterproyecto/util/mensaje_util.dart';
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
              //boton para ver mis recetas
              leading: Container(
                decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MostrarRecetas()));
                    },
                    icon: Icon(MdiIcons.book)),
              ),
              //boton para salir de la aplicacion
              trailing: Container(
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      MensajeUtil().ShowSnackbar('Sesion cerrada', context, 5);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (Route<dynamic> route) => false);
                    },
                    icon: Icon(MdiIcons.logout)),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AgregarReceta()));
            },
            backgroundColor: Color(ColorPrimario),
            foregroundColor: Colors.white,
            child: Icon(MdiIcons.plus),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          body: StreamBuilder(
            stream: FirebaseService().recetas(),
            builder: (BuildContext context, AsyncSnapshot snapshotRecetas) {
              if (!snapshotRecetas.hasData ||
                  snapshotRecetas.connectionState == ConnectionState.waiting) {
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
                            onPressed: (context) {
                              this._confirmBorrado(context).then((borrar) {
                                if (borrar) {
                                  setState(() {
                                    FirebaseService().borrarReceta(receta.id);
                                    //el dialogo de confirmacion se entendio como un showdialog y no un snackbar
                                  });
                                }
                              });
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
                            future: FirebaseService()
                                .buscarFoto(receta['categoria']),
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
                                    instrucciones: receta['instrucciones'],
                                    id: receta.id,
                                  )));
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
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<dynamic> _confirmBorrado(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmar Borrado'),
            content: Text('Borrar Piloto?'),
            actions: [
              TextButton(
                child: Text('CANCELAR'),
                onPressed: () => Navigator.pop(context, false),
              ),
              ElevatedButton(
                child: Text('ACEPTAR'),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          );
        });
  }
}
