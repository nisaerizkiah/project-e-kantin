import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider_lilis.dart';

class CartScreen_ajeng extends StatelessWidget {
  CartScreen_ajeng({Key? key}) : super(key: key);

  // menambahkan loading pop up
  void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Colors.deepPurple),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProviderLilis>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      appBar: AppBar(
        title: const Text("Keranjang", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: cart.items.isEmpty
          ? const Center(
              child: Text(
                "Keranjang kamu masih kosong",
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(18),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final product = cart.items.keys.toList()[index];
                      final qty = cart.items.values.toList()[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                        
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),

                                Row(
                                  children: [
                                    // ====== BUTTON MINUS ======
                                    GestureDetector(
                                      onTap: () => cart.decreaseItem(product),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: const Text(
                                          "-",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    Text(
                                      "$qty",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    
                                    GestureDetector(
                                      onTap: () => cart.addItem(product),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: const Text(
                                          "+",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            
                            Text(
                              "Rp ${product.price}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      
                      TextField(
                        decoration: const InputDecoration(
                          labelText: "Masukkan NIM",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          cart.setUserNim(value);

                          if (value.isNotEmpty) {
                            final last =
                                int.tryParse(value[value.length - 1]) ?? 0;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  last % 2 == 0
                                      ? "NIM Genap → Kamu dapat GRATIS ONGKIR!"
                                      : "NIM Ganjil → Kamu dapat DISKON 5%!",
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 18),

                      
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Subtotal: Rp ${cart.subTotal.toStringAsFixed(0)}",
                          ),

                          const SizedBox(height: 6),

                          if (cart.userNim.isNotEmpty)
                            Text(
                              "Diskon: - Rp ${cart.discount.toStringAsFixed(0)}",
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                          const SizedBox(height: 6),

                          if (cart.userNim.isNotEmpty)
                            Text(
                              cart.shippingCost == 0
                                  ? "Ongkir: GRATIS"
                                  : "Ongkir: Rp ${cart.shippingCost.toStringAsFixed(0)}",
                              style: TextStyle(
                                color: cart.shippingCost == 0
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                          const Divider(height: 20),

                          Text(
                            "Total Bayar: Rp ${cart.finalTotal.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 17),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () async {
                          if (cart.userNim.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Masukkan NIM dulu"),
                              ),
                            );
                            return;
                          }

                          // SHOW LOADING
                          showLoading(context);

                          final success = await cart.checkout();

                          // CLOSE LOADING
                          Navigator.pop(context);

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Pembayaran Berhasil!"),
                              ),
                            );
                            cart.clearCart();
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Gagal Checkout")),
                            );
                          }
                        },
                        child: const Text(
                          "Bayar Sekarang",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
