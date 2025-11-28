import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../services/firebase_services_kifiyah.dart';
import '../providers/cart_provider_lilis.dart';
import 'home_screen_ajeng.dart';
import 'register_screen_ajeng.dart';

class LoginScreen_ajeng extends StatefulWidget {
  const LoginScreen_ajeng({super.key});

  @override
  State<LoginScreen_ajeng> createState() => _LoginScreen_ajengState();
}

class _LoginScreen_ajengState extends State<LoginScreen_ajeng> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseServiceKifiyah _firebaseService = FirebaseServiceKifiyah();

  bool isLoading = false;

  Future<void> loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan password wajib diisi")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await _firebaseService.signIn(email, password);

      // 🔥 Ambil NIM user dari Firebase
      String? nim = await _firebaseService.getNimByEmail(email);
      print("NIM user: $nim");

      // 🔥 Simpan NIM ke provider supaya checkout & diskon aktif
      if (nim != null) {
        final cartProvider = Provider.of<CartProviderLilis>(context, listen: false);
        cartProvider.setUserNim(nim);
        print("NIM berhasil dimasukkan ke CartProvider: $nim");
      }

      if (!mounted) return;

      // 🔥 Pindah ke Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreenAjeng()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login gagal: $e")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // HEADER
            Container(
              height: 230,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(120),
                  bottomRight: Radius.circular(120),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.storefront_rounded,
                  size: 90,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 35),

            // FORM LOGIN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontFamily: "Sora",
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Login to continue ordering",
                      style: TextStyle(
                        fontFamily: "Sora",
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // EMAIL
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.sms),
                        hintText: "Email Kampus",
                        filled: true,
                        fillColor: const Color(0xFFF3E9FF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // PASSWORD
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.lock),
                        hintText: "Password",
                        filled: true,
                        fillColor: const Color(0xFFF3E9FF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // LOGIN BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: isLoading ? null : loginUser,
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Login",
                                style: TextStyle(
                                  fontFamily: "Sora",
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // LINK REGISTER
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen_ajeng(),
                            ),
                          );
                        },
                        child: const Text(
                          "Belum punya akun? Daftar",
                          style: TextStyle(
                            fontFamily: "Sora",
                            fontSize: 14,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}