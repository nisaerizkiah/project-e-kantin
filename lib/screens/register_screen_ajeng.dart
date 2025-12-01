import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../services/firebase_services_kifiyah.dart';
import 'login_screen_ajeng.dart';

class RegisterScreen_ajeng extends StatefulWidget {
  const RegisterScreen_ajeng({super.key});

  @override
  State<RegisterScreen_ajeng> createState() => _RegisterScreen_ajengState();
}

class _RegisterScreen_ajengState extends State<RegisterScreen_ajeng> {
  final TextEditingController nimController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final FirebaseServiceKifiyah _firebaseService = FirebaseServiceKifiyah();
  bool isLoading = false;

  Future<void> registerUser() async {
    String nim = nimController.text.trim();
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (nim.isEmpty || name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field wajib diisi")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password tidak sama")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await _firebaseService.signUp(email, password, nim);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pendaftaran Berhasil, silakan login")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen_ajeng()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pendaftaran gagal: $e")),
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

            // CARD REGISTER
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
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Daftar Akun",
                      style: TextStyle(
                        fontFamily: "Sora",
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Buat akun untuk mulai memesan",
                      style: TextStyle(
                        fontFamily: "Sora",
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // NIM
                    TextField(
                      controller: nimController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.card),
                        hintText: "NIM (User ID)",
                        filled: true,
                        fillColor: const Color(0xFFF3E9FF),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // NAMA LENGKAP
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.user),
                        hintText: "Nama Lengkap",
                        filled: true,
                        fillColor: const Color(0xFFF3E9FF),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // EMAIL
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.sms),
                        hintText: "Email",
                        filled: true,
                        fillColor: const Color(0xFFF3E9FF),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(14),
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
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // KONFIRMASI PASSWORD
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.lock),
                        hintText: "Konfirmasi Password",
                        filled: true,
                        fillColor: const Color(0xFFF3E9FF),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // BUTTON DAFTAR
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
                        onPressed: isLoading ? null : registerUser,
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Daftar",
                                style: TextStyle(
                                  fontFamily: "Sora",
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen_ajeng()),
                          );
                        },
                        child: const Text(
                          "Sudah punya akun? Login",
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