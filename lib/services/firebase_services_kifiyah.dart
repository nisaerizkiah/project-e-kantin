import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model_kifiyah.dart';

class FirebaseServiceKifiyah {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // REGISTER (MODEL LAMA)
  Future<void> registerUser(UserModelKifiyah user) async {
    await _firestore.collection('Users').doc(user.userId).set({
      'user_id': user.userId,
      'name': user.name,
      'email': user.email,
      'password': user.password,
      'created_at': DateTime.now()
    });
  }

  // SIGN UP (REGISTRASI EMAIL & PASSWORD)
  Future<void> signUp(String email, String password, String nim) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('Users').doc(credential.user!.uid).set({
        'user_id': nim,
        'email': email,
        'created_at': DateTime.now(),
      });
    } catch (e) {
      throw Exception("Register error: $e");
    }
  }

  // LOGIN
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // GET NIM USER DARI EMAIL
  Future<String?> getNimByEmail(String email) async {
    final query = await _firestore
        .collection('Users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (query.docs.isEmpty) return null;

    final doc = query.docs.first.data();
    return (doc['user_id'] ?? doc['nim'])?.toString();
  }

  //  UPDATE STOK SAAT CHECKOUT
  // change = { "Air Mineral": 2, "Nasi Goreng": 1 }
  Future<void> updateStockTransaction(Map<String, int> change) async {
    final batch = _firestore.batch();

    for (var entry in change.entries) {
      final productId = entry.key;
      final qty = entry.value;

      final ref = _firestore.collection("Product").doc(productId);
      final snapshot = await ref.get();

      if (!snapshot.exists) {
        print("Product $productId tidak ditemukan di Firebase");
        continue;
      }

      final currentStock = snapshot.data()?['stock'] ?? 0;
      final newStock = currentStock - qty;

      batch.update(ref, {'stock': newStock});
    }

    await batch.commit();
  }

  // SIMPAN TRANSAKSI
  Future<void> createTransactionRecord(Map<String, dynamic> trxDoc) async {
    await _firestore
        .collection("Transaction")
        .doc(trxDoc['trx_id'])
        .set(trxDoc);
  }
}