import 'package:flutter/material.dart';
import 'package:flutterproyecto/pages/colores.dart';
import 'package:flutterproyecto/services/auth_service.dart';
import 'package:flutterproyecto/services/firebase_service.dart';

class AgregarReceta extends StatefulWidget {
  const AgregarReceta({super.key});

  @override
  State<AgregarReceta> createState() => _AgregarRecetaState();
}

class _AgregarRecetaState extends State<AgregarReceta> {
  String categoriaSeleccionada = "";
  TextEditingController nombre = TextEditingController();
  TextEditingController instrucciones = TextEditingController();
  String autor = "", email = "";
  final formKey = GlobalKey<FormState>();
  String mensaje = "";
  bool datosUsuario = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(ColorPrimario),
        title: Text("Agregar Receta"),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                TextFormField(
                  controller: nombre,
                  decoration: InputDecoration(labelText: 'Escriba el nombre'),
                  validator: (nombre) {
                    if (nombre!.isEmpty) {
                      return 'La receta requiere un nombre';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: instrucciones,
                  decoration:
                      InputDecoration(labelText: 'Escriba las instrucciones'),
                  validator: (instrucciones) {
                    if (instrucciones!.isEmpty) {
                      return 'La receta requiere instrucciones';
                    }
                    return null;
                  },
                ),
                StreamBuilder(
                  stream: FirebaseService().categorias(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Cargando categorias");
                    }
                    ;
                    var categorias = snapshot.data.docs.toList();
                    List<DropdownMenuItem> categoriaItems = categorias;
                    if (categoriaSeleccionada == "") {
                      categoriaSeleccionada = categorias[0]['categoria'];
                    }
                    return DropdownButtonFormField(
                      decoration: InputDecoration(
                          labelText: "Seleccione una categoria"),
                      value: categorias[0]['categoria'],
                      onChanged: (value) {
                        categoriaSeleccionada = value!;
                      },
                      items: categoriaItems,
                    );
                  },
                ),
                FutureBuilder(
                  future: AuthService().usuarioActual(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return Text("");
                    }
                    autor = snapshot.data!.displayName!;
                    email = snapshot.data!.email!;
                    datosUsuario = true;
                    return Text("");
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate() &&
                        datosUsuario == true) {
                      FirebaseService().agregarReceta(
                          nombre.text.trim(),
                          instrucciones.text.trim(),
                          categoriaSeleccionada,
                          autor,
                          email);
                      Navigator.pop(context);
                    }
                    ;
                  },
                  child: Text("Agregar Receta"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(ColorSecundario)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
