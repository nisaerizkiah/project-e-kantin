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

  // Add Nim Setter
  void setUserNim(String nim) {
    userNim = nim;
    notifyListeners();
  }

  double get subTotal {
    double total = 0;
    items.forEach((product, qty) {
      total += product.price * qty;
    });
    return total;
  }

  //Business Logic
  double get discount {
    if (userNim.isEmpty) return 0;

    int lastDigit = int.parse(userNim[userNim.length - 1]);

    if (lastDigit % 2 != 0) {
      return subTotal * 0.05;
    }
    return 0;
  }

  double get shippingCost {
    if (userNim.isEmpty) return 5000;

    int lastDigit = int.parse(userNim[userNim.length - 1]);

    return lastDigit % 2 == 0 ? 0 : 5000;
  }

  double get finalTotal => subTotal - discount + shippingCost;

  // Firestore Checkout
  Future<bool> checkout() async {
    if (userNim.isEmpty || items.isEmpty) return false;

    try {
      await _db.collection("Transactions").add({
        "trx_id": DateTime.now().millisecondsSinceEpoch.toString(),
        "user_nim": userNim,
        "sub_total": subTotal,
        "discount": discount,
        "shipping_cost": shippingCost,
        "total_final": finalTotal,
        "status": "Success",
        "items": items.entries
            .map(
              (e) => {"name": e.key.name, "price": e.key.price, "qty": e.value},
            )
            .toList(),
        "timestamp": FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print("Checkout Error: $e");
      return false;
    }
  }
}