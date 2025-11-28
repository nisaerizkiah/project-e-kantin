import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider_lilis.dart';
import '../models/product_model_kifiyah.dart';
import 'cart_screen_ajeng.dart';

class HomeScreenAjeng extends StatelessWidget {
  HomeScreenAjeng({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> menuItems = [
    {"name": "Air Mineral", "image": "assets/images/air mineral.jpeg", "price": 5000},
    {"name": "Ayam Geprek", "image": "assets/images/ayam geprek.jpeg", "price": 15000},
    {"name": "Bakso", "image": "assets/images/bakso.jpeg", "price": 12000},
    {"name": "Boba", "image": "assets/images/boba.jpeg", "price": 15000},
    {"name": "Es Teh", "image": "assets/images/es teh.jpeg", "price": 4000},
    {"name": "Jus Alpukat", "image": "assets/images/jus alpukat.jpeg", "price": 9000},
    {"name": "Jus Jeruk", "image": "assets/images/jus jeruk.jpeg", "price": 8000},
    {"name": "Mie Ayam", "image": "assets/images/mie ayam.jpeg", "price": 12000},
    {"name": "Nasi Goreng", "image": "assets/images/nasi goreng.jpeg", "price": 13000},
    {"name": "Sosis Bakar", "image": "assets/images/sosis bakar.jpeg", "price": 7000},
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProviderLilis>(context, listen: false);

    return Scaffold(
      backgroundColor: Color(0xFFF8F5FF),
      appBar: AppBar(
        title: Text("E-Kantin", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          Consumer<CartProviderLilis>(
            builder: (context, cart, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CartScreen_ajeng()),
                      );
                    },
                  ),
                  if (cart.items.length > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          cart.items.length.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                ],
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.all(14),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 3 / 4,
          ),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            final item = menuItems[index];

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      child: Image.asset(item["image"], fit: BoxFit.cover),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item["name"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text("Rp ${item["price"]}", style: TextStyle(fontSize: 14, color: Colors.black54)),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: SizedBox(
                      height: 42,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () {
                          final product = ProductModelKifiyah(
                            productId: item["name"],
                            name: item["name"],
                            price: (item["price"] as num).toDouble(),   // 🔥 perbaikan penting
                            stock: 1,
                            imageUrl: item["image"],
                          );

                          cart.addItem(product);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${item["name"]} ditambahkan ke keranjang"),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Text("Tambah", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}