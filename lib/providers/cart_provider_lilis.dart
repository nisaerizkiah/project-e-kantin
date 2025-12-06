import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product_model_kifiyah.dart';

class CartProviderLilis extends ChangeNotifier {
  Map<ProductModelKifiyah, int> items = {};
  String userNim = "";
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void addItem(ProductModelKifiyah product) {
    if (items.containsKey(product)) {
      items[product] = items[product]! + 1;
    } else {
      items[product] = 1;
    }
    notifyListeners();
  }

  void decreaseItem(ProductModelKifiyah product) {
    if (items.containsKey(product)) {
      if (items[product] == 1) {
        items.remove(product);
      } else {
        items[product] = items[product]! - 1;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    items.clear();
    notifyListeners();
  }

  void setUserNim(String nim) {
    userNim = nim;
    notifyListeners();
  }

  double get subTotal {
    return items.entries.fold(0, (sum, e) => sum + (e.key.price * e.value));
  }

  double get discount {
    if (userNim.isEmpty) return 0;
    int lastDigit = int.parse(userNim[userNim.length - 1]);
    return lastDigit % 2 != 0 ? subTotal * 0.05 : 0;
  }

  double get shippingCost {
    if (userNim.isEmpty) return 5000;
    int lastDigit = int.parse(userNim[userNim.length - 1]);
    return lastDigit % 2 == 0 ? 0 : 5000;
  }

  double get finalTotal => subTotal - discount + shippingCost;

  Future<bool> checkout() async {
    if (userNim.isEmpty || items.isEmpty) return false;

    try {
      WriteBatch batch = _db.batch();

      for (var entry in items.entries) {
        var product = entry.key;
        var qty = entry.value;

        var docRef = _db.collection("products").doc(product.productId);

        product.stock -= qty;
        batch.update(docRef, {"stock": product.stock});
      }

      await batch.commit();

      await _db.collection("Transactions").add({
        "trx_id": DateTime.now().millisecondsSinceEpoch.toString(),
        "user_nim": userNim,
        "total_final": finalTotal,
        "items": items.entries
            .map((e) => {
                  "name": e.key.name,
                  "qty": e.value,
                })
            .toList(),
        "timestamp": FieldValue.serverTimestamp(),
      });

      clearCart();
      notifyListeners();

      return true;
    } catch (e) {
      print("Checkout Error: $e");
      return false;
    }
  }
}