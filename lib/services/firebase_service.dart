import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

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

  Future<dynamic> buscarFoto(String categoria) {
    return FirebaseFirestore.instance
        .collection('categorias')
        .where('categoria', isEqualTo: categoria)
        .get();
  }

  Future<void> borrarReceta(String id) {
    return FirebaseFirestore.instance.collection('recetas').doc(id).delete();
  }
}
