import 'package:cloud_firestore/cloud_firestore.dart'; 

class ProductModelKifiyah {
  final String productId;
  final String name;
  final double price;
  int stock;
  final String imageUrl;

  ProductModelKifiyah({
    required this.productId,
    required this.name,
    required this.price,
    required this.stock,
    required this.imageUrl,
  });

  factory ProductModelKifiyah.fromJson(Map<String, dynamic> json) {
    return ProductModelKifiyah(
      productId: json['product_id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stock: (json['stock'] ?? 0).toInt(),
      imageUrl: json['image_url'] ?? '',
    );
  }

  factory ProductModelKifiyah.fromFirestore(DocumentSnapshot doc) {
    return ProductModelKifiyah.fromJson(doc.data() as Map<String, dynamic>);
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'price': price,
      'stock': stock,
      'image_url': imageUrl,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is ProductModelKifiyah && other.productId == productId;
  }

  @override
  int get hashCode => productId.hashCode;
}