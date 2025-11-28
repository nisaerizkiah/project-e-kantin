import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../models/user_model_kifiyah.dart';
import '../services/firebase_services_kifiyah.dart';
import '../providers/cart_provider_lilis.dart';

class AuthControllerNisa {
  final FirebaseServiceKifiyah _svc = FirebaseServiceKifiyah();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? validatePassword(String? v) {
    if (v == null || v.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  Future<bool> register(UserModelKifiyah user, BuildContext context) async {
    try {
      await _svc.registerUser(user);
      await _auth.signInWithEmailAndPassword(email: user.email, password: user.password);

      // set user nim into CartProviderLilis
      final cartProv = Provider.of<CartProviderLilis>(context, listen: false);
      cartProv.setUserNim(user.userId);

      Navigator.pushReplacementNamed(context, '/home');
      return true;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Register error')));
      return false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      return false;
    }
  }

  Future<bool> signIn(String email, String password, BuildContext context) async {
    try {
      await _svc.signIn(email, password);

      final currentUser = _auth.currentUser;
      String nim = '';

      if (currentUser != null) {
        // FIXED: Ambil NIM lewat service, bukan akses private field
        nim = await _svc.getNimByEmail(currentUser.email!) ?? '';
      }

      final cartProv = Provider.of<CartProviderLilis>(context, listen: false);
      if (nim.isNotEmpty) cartProv.setUserNim(nim);

      Navigator.pushReplacementNamed(context, '/home');
      return true;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Login error')));
      return false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      return false;
    }
  }
}
