import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterproyecto/pages/colores.dart';
import 'package:flutterproyecto/pages/home_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController correoCtrl = TextEditingController();
  TextEditingController ContraCtrl = TextEditingController();
  String mensaje = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Color(ColorSecundario),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  color: Colors.white),
              child: Form(
                  child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: ListView(
                  children: [
                    Container(
                      child: Icon(
                        MdiIcons.cupcake,
                        size: 75,
                        color: Color(ColorSecundario),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 150),
                      child: TextFormField(
                        decoration:
                            InputDecoration(hintText: "Introduzca su Correo"),
                        controller: correoCtrl,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: "Introduzca su Contraseña"),
                        controller: ContraCtrl,
                        obscureText: true,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Container(
                        width: double.infinity,
                        child: FilledButton(
                            onPressed: () async {
                              try {
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: correoCtrl.text.trim(),
                                  password: ContraCtrl.text.trim(),
                                );
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()));
                              } on FirebaseAuthException catch (ex) {
                                setState(
                                  () {
                                    switch (ex.code) {
                                      case 'channel-error':
                                        mensaje =
                                            'Ingrese los datos solicitados';
                                        break;
                                      case 'invalid-email':
                                        mensaje = 'Correo no valido';
                                        break;
                                      case 'invalid-credential':
                                        mensaje = 'Credenciales no validas';
                                        break;
                                      case 'user-disabled':
                                        mensaje =
                                            'El usuario a sido deshabilitado';
                                        break;
                                      default:
                                        //mensaje =
                                        //    'Error no especificado, contactese con el administrador';
                                        print(mensaje);
                                    }
                                  },
                                );
                              }
                            },
                            child: Text("Iniciar sesion")),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Text(
                        mensaje,
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
