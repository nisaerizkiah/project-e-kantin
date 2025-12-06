import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../models/user_model_kifiyah.dart';
import '../services/firebase_services_kifiyah.dart';
import '../providers/cart_provider_lilis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthControllerNisa {
  final FirebaseServiceKifiyah _svc = FirebaseServiceKifiyah();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? validatePassword(String? v) {
    if (v == null || v.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  
  Future<bool> register(UserModelKifiyah user, BuildContext context) async {
    try {
     
      final checkEmail = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      if (checkEmail.docs.isNotEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Email sudah digunakan!")),
          );
        }
        return false;
      }

      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      final uid = cred.user!.uid; 

      await FirebaseFirestore.instance.collection('Users').doc(uid).set({
        'uid': uid,
        'user_id': user.userId,
        'full_name': user.fullName,
        'email': user.email,
        'password': user.password,
        'created_at': DateTime.now(),
      });

      
      if (!context.mounted) return false;

     
      Provider.of<CartProviderLilis>(context, listen: false)
          .setUserNim(user.userId);

  
      Navigator.pushReplacementNamed(context, '/home');

      return true;

    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Register error')),
        );
      }
      return false;

    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
      return false;
    }
  }

  
  Future<bool> signIn(String email, String password, BuildContext context) async {
    try {
      await _svc.signIn(email, password);

      final currentUser = _auth.currentUser;
      String nim = '';

      if (currentUser != null) {
        nim = await _svc.getNimByEmail(currentUser.email!) ?? '';
      }

      if (!context.mounted) return false;

      final cartProv = Provider.of<CartProviderLilis>(context, listen: false);
      if (nim.isNotEmpty) cartProv.setUserNim(nim);

      Navigator.pushReplacementNamed(context, '/home');
      return true;

    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Login error')),
        );
      }
      return false;

    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
      return false;
    }
  }
}