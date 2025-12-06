import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider_lilis.dart';
import '../models/product_model_kifiyah.dart';
import '../services/firebase_services_kifiyah.dart';
import 'cart_screen_ajeng.dart';

class HomeScreenAjeng extends StatefulWidget {
  const HomeScreenAjeng({super.key});

  @override
  State<HomeScreenAjeng> createState() => _HomeScreenAjengState();
}

class _HomeScreenAjengState extends State<HomeScreenAjeng> {
  final FirebaseServiceKifiyah _firebase = FirebaseServiceKifiyah();
  bool initialized = false;

  final List<Map<String, dynamic>> defaultMenu = [
    {
      "name": "Air Mineral",
      "image": "assets/images/air mineral.jpeg",
      "price": 5000,
      "stock": 5,
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
      "stock": 7,
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

  @override
  void initState() {
    super.initState();
    setupProducts();
  }

  Future<void> setupProducts() async {
    final data = await _firebase.getProducts();

    if (data.isEmpty) {
      for (var item in defaultMenu) {
        await _firebase.addProduct(
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

    setState(() => initialized = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      appBar: AppBar(
        title: const Text("E-Kantin", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          Consumer<CartProviderLilis>(
            builder: (context, cart, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CartScreenAjeng(),
                        ),
                      );
                    },
                  ),
                  if (cart.items.isNotEmpty)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          cart.items.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),

      body: !initialized
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<ProductModelKifiyah>>(
              stream: _firebase.getProductsStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final products = snapshot.data!;

                return GridView.builder(
                  padding: const EdgeInsets.all(14),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final item = products[index];

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                              child: Image.asset(
                                item.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Rp ${item.price.toInt()}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Stok: ${item.stock}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            child: SizedBox(
                              height: 42,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: item.stock > 0
                                    ? () async {
                                        await _firebase.updateProductStock(
                                          item.productId,
                                          item.stock - 1,
                                        );

                                        if (!mounted) return;

                                        Provider.of<CartProviderLilis>(
                                          context,
                                          listen: false,
                                        ).addItem(item);
                                      }
                                    : null,
                                child: const Text(
                                  "Tambah",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
