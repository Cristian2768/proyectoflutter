import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  Stream<QuerySnapshot> recetas() {
    return FirebaseFirestore.instance.collection('recetas').snapshots();
  }

  Future<dynamic> RecetaInstruccion(
      String correo, String nombre, String instrucciones) {
    return FirebaseFirestore.instance
        .collection('recetas')
        .where('correo', isEqualTo: correo)
        .where('nombre', isEqualTo: nombre)
        .where('instrucciones', isEqualTo: instrucciones)
        .get();
  }
}
