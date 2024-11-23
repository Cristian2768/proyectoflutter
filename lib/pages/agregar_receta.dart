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
  String categoriaSeleccionada = "0";
  TextEditingController nombre = TextEditingController();
  TextEditingController instrucciones = TextEditingController();
  TextEditingController correo = TextEditingController();
  TextEditingController autor = TextEditingController();
  final formKey = GlobalKey<FormState>();

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
                FutureBuilder(
                  future: AuthService().usuarioActual(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Cargando correo...");
                    }
                    autor.text = snapshot.data!.displayName!;
                    return TextFormField(
                      controller: autor,
                      decoration: InputDecoration(labelText: 'Autor'),
                      enabled: false,
                    );
                  },
                ),
                FutureBuilder(
                  future: AuthService().usuarioActual(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Cargando correo...");
                    }
                    correo.text = snapshot.data!.email!;
                    return TextFormField(
                      controller: correo,
                      decoration:
                          InputDecoration(labelText: 'Correo del creador'),
                      enabled: false,
                    );
                  },
                ),
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
                    List<DropdownMenuItem> categoriaItems = [];
                    if (!snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Cargando categorias...');
                    }
                    ;
                    var categorias = snapshot.data?.docs.reversed.toList();
                    categoriaItems.add(DropdownMenuItem(
                      value: "0",
                      child: Text("Seleccione la categoria"),
                    ));
                    for (var categoria in categorias!) {
                      categoriaItems.add(
                        DropdownMenuItem(
                          value: categoria['categoria'],
                          child: Text(categoria['categoria']),
                        ),
                      );
                    }
                    return DropdownButtonFormField(
                      validator: (categoriaSeleccionada) {
                        if (categoriaSeleccionada == "0") {
                          return 'Debe seleccionar una categoria';
                        }
                        ;
                        return null;
                      },
                      value: categoriaSeleccionada,
                      items: categoriaItems,
                      onChanged: (value) {
                        setState(() {
                          categoriaSeleccionada = value;
                        });
                        //print(categoriaSeleccionada);
                      },
                      isExpanded: false,
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      FirebaseService().agregarReceta(
                          nombre.text.trim(),
                          instrucciones.text.trim(),
                          categoriaSeleccionada,
                          autor.text.trim(),
                          correo.text.trim());
                      Navigator.pop(context);
                    }
                    ;
                  },
                  child: Text("Agregar Receta"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(ColorSecundario)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
