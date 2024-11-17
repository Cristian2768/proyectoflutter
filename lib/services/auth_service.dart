import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final Auth = FirebaseAuth.instance;

  Future<UserCredential?> iniciarSesionGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);

      return await Auth.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<User?> usuarioActual() async {
    return FirebaseAuth.instance.currentUser;
  }
}
