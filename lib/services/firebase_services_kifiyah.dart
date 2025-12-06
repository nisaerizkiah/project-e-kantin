import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model_kifiyah.dart';
import '../models/product_model_kifiyah.dart';

class FirebaseServiceKifiyah {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<Map<String, dynamic>> defaultMenu = [
    {
      "name": "Air Mineral",
      "image": "assets/images/air mineral.jpeg",
      "price": 5000,
      "stock": 10,
    },
    {
      "name": "Ayam Geprek",
      "image": "assets/images/ayam geprek.jpeg",
      "price": 15000,
      "stock": 9,
    },
    {
      "name": "Bakso",
      "image": "assets/images/bakso.jpeg",
      "price": 12000,
      "stock": 8,
    },
    {
      "name": "Boba",
      "image": "assets/images/boba.jpeg",
      "price": 15000,
      "stock": 8,
    },
    {
      "name": "Es Teh",
      "image": "assets/images/es teh.jpeg",
      "price": 4000,
      "stock": 10,
    },
    {
      "name": "Jus Alpukat",
      "image": "assets/images/jus alpukat.jpeg",
      "price": 9000,
      "stock": 10,
    },
    {
      "name": "Jus Jeruk",
      "image": "assets/images/jus jeruk.jpeg",
      "price": 7000,
      "stock": 10,
    },
    {
      "name": "Mie Ayam",
      "image": "assets/images/mie ayam.jpeg",
      "price": 12000,
      "stock": 10,
    },
    {
      "name": "Nasi Goreng",
      "image": "assets/images/nasi goreng.jpeg",
      "price": 13000,
      "stock": 10,
    },
    {
      "name": "Sosis Bakar",
      "image": "assets/images/sosis bakar.jpeg",
      "price": 10000,
      "stock": 10,
    },
  ];

  
  Future<void> seedProductsIfEmpty() async {
    final snap = await _firestore.collection("products").get();

   
    if (snap.docs.isEmpty) {
      for (var item in defaultMenu) {
        await addProduct(
          ProductModelKifiyah(
            productId: item["name"],
            name: item["name"],
            price: (item["price"] as num).toDouble(),
            stock: item["stock"],
            imageUrl: item["image"],
          ),
        );
      }
    }
  }

  Future<void> registerUser(UserModelKifiyah user) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      String uid = cred.user!.uid;

      await _firestore.collection('Users').doc(uid).set({
        'uid': uid,
        'user_id': user.userId, 
        'full_name': user.fullName,
        'email': user.email,
        'password': user.password,
        'created_at': DateTime.now(),
      });
    } catch (e) {
      throw Exception("RegisterUser Error → $e");
    }
  }

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<String?> getNimByEmail(String email) async {
    final q = await _firestore
        .collection('Users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (q.docs.isEmpty) return null;
    return q.docs.first['user_id'];
  }

  
  Future<void> addProduct(ProductModelKifiyah product) async {
    await _firestore
        .collection("products")
        .doc(product.productId)
        .set(product.toJson());
  }

  Stream<List<ProductModelKifiyah>> getProductsStream() {
    return _firestore.collection("products").snapshots().map((snap) {
      return snap.docs
          .map((doc) => ProductModelKifiyah.fromFirestore(doc))
          .toList();
    });
  }

  Future<List<ProductModelKifiyah>> getProducts() async {
    final snap = await _firestore.collection("products").get();
    return snap.docs
        .map((doc) => ProductModelKifiyah.fromFirestore(doc))
        .toList();
  }

  Future<void> updateProduct(ProductModelKifiyah product) async {
    await _firestore
        .collection("products")
        .doc(product.productId)
        .update(product.toJson());
  }

  Future<void> deleteProduct(String productId) async {
    await _firestore.collection("products").doc(productId).delete();
  }

  Future<void> updateProductStock(String productId, int newStock) async {
    await _firestore.collection("products").doc(productId).update({
      "stock": newStock,
    });
  }

  
  Future<void> updateStockTransaction(Map<String, int> change) async {
    final batch = _firestore.batch();

    for (var entry in change.entries) {
      final ref = _firestore.collection("products").doc(entry.key);
      final doc = await ref.get();
      if (!doc.exists) continue;

      final currentStock = doc.data()?['stock'] ?? 0;
      batch.update(ref, {'stock': currentStock - entry.value});
    }

    await batch.commit();
  }

  Future<void> createTransactionRecord(Map<String, dynamic> trx) async {
    await _firestore.collection("Transactions").doc(trx['trx_id']).set(trx);
  }
}