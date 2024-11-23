import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  Stream<QuerySnapshot> recetas() {
    return FirebaseFirestore.instance.collection('recetas').snapshots();
  }

  Future<dynamic> recetasPropias(String correo) {
    return FirebaseFirestore.instance
        .collection('recetas')
        .where('correo', isEqualTo: correo)
        .get();
  }

  Stream<QuerySnapshot> categorias() {
    return FirebaseFirestore.instance.collection('categorias').snapshots();
  }

  Future<dynamic> RecetaInstruccion(
      String correo, String nombre, String instrucciones, String id) {
    return FirebaseFirestore.instance.collection('recetas').doc(id).get();
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

  Future<void> agregarReceta(String nombre, String instrucciones,
      String categoria, String autor, String correo) {
    return FirebaseFirestore.instance.collection('recetas').doc().set({
      'nombre': nombre,
      'instrucciones': instrucciones,
      'categoria': categoria,
      'autor': autor,
      'correo': correo
    });
  }
}
