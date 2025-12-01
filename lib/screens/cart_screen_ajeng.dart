import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider_lilis.dart';

class CartScreen_ajeng extends StatelessWidget {
  CartScreen_ajeng({Key? key}) : super(key: key);

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
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
        title: const Text("Keranjang Belanja", style: TextStyle(color: Colors.white)),
        elevation: 0,
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
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final product = cart.items.keys.toList()[index];
                      final qty = cart.items.values.toList()[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
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
                                    GestureDetector(
                                      onTap: () => cart.decreaseItem(product),
                                      child: buttonQty("-", Colors.deepPurple),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      "$qty",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: () => cart.addItem(product),
                                      child: buttonQty("+", Colors.deepPurple),
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

                // ======= BOTTOM SECTION (NO INPUT NIM) =======
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
                      // NIM otomatis dari login
                      Text(
                        "NIM: ${cart.userNim}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Promo info otomatis berdasarkan digit terakhir NIM
                      if (cart.userNim.isNotEmpty)
                        Text(
                          int.parse(cart.userNim[cart.userNim.length - 1]) % 2 == 0
                              ? "NIM Genap: Gratis Ongkir!"
                              : "NIM Ganjil: Diskon 5%!",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),

                      const SizedBox(height: 18),

                      Text("Subtotal: Rp ${cart.subTotal.toStringAsFixed(0)}"),
                      const SizedBox(height: 6),

                      Text(
                        "Diskon: - Rp ${cart.discount.toStringAsFixed(0)}",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),

                      Text(
                        cart.shippingCost == 0
                            ? "Ongkir: GRATIS"
                            : "Ongkir: Rp ${cart.shippingCost.toStringAsFixed(0)}",
                        style: TextStyle(
                          color: cart.shippingCost == 0 ? Colors.green : Colors.red,
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

                      const SizedBox(height: 18),

                      // CHECKOUT BUTTON
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 17),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () async {
                          showLoading(context);
                          final success = await cart.checkout();
                          Navigator.pop(context);

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Pembayaran Berhasil!")),
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
                          "Checkout Sekarang",
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

  Widget buttonQty(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      child: Text(
        label,
        style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}