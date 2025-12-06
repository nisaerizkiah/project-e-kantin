import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../controllers/auth_controller_nisa.dart';
import '../models/user_model_kifiyah.dart';
import 'login_screen_ajeng.dart';

class RegisterScreenAjeng extends StatefulWidget {
  const RegisterScreenAjeng({super.key});

  @override
  State<RegisterScreenAjeng> createState() => _RegisterScreenAjengState();
}

class _RegisterScreenAjengState extends State<RegisterScreenAjeng> {
  final TextEditingController nimController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  Future<void> registerUser() async {
    final nim = nimController.text.trim();
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (nim.isEmpty ||
        name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Semua field wajib diisi")));
      return;
    }

    if (!email.contains("@") || !email.contains(".")) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Format email tidak valid")));
      return;
    }

    if (password != confirmPassword) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Password tidak sama")));
      return;
    }

    setState(() => isLoading = true);

    final userModel = UserModelKifiyah(
      userId: nim,
      fullName: name,
      email: email,
      password: password,
    );

    try {
      final success = await AuthControllerNisa().register(userModel, context);

      if (success && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Pendaftaran berhasil")));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreenAjeng()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Pendaftaran gagal: $e")));
      }
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFF8F5FF),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),

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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: buildRegisterCard(),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),

        if (isLoading)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withValues(alpha: 0.45),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget buildRegisterCard() {
    return Container(
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

          buildInput(
            "NIM (User ID)",
            nimController,
            Iconsax.card,
            TextInputType.number,
          ),
          const SizedBox(height: 18),

          buildInput("Nama Lengkap", nameController, Iconsax.user),
          const SizedBox(height: 18),

          buildInput(
            "Email",
            emailController,
            Iconsax.sms,
            TextInputType.emailAddress,
          ),
          const SizedBox(height: 18),

          buildInput("Password", passwordController, Iconsax.lock, null, true),
          const SizedBox(height: 18),

          buildInput(
            "Konfirmasi Password",
            confirmPasswordController,
            Iconsax.lock,
            null,
            true,
          ),
          const SizedBox(height: 30),

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
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ),

          const SizedBox(height: 16),

          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreenAjeng()),
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
    );
  }

  Widget buildInput(
    String hint,
    TextEditingController ctrl,
    IconData icon, [
    TextInputType? type,
    bool obscure = false,
  ]) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      keyboardType: type,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF3E9FF),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
