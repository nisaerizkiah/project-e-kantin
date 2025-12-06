import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/cart_provider_lilis.dart';

import 'screens/login_screen_ajeng.dart';
import 'screens/register_screen_ajeng.dart';
import 'screens/home_screen_ajeng.dart';
import 'screens/cart_screen_ajeng.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProviderLilis()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart E-Kantin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: "Sora",
        useMaterial3: true,
      ),

      home: const LoginScreenAjeng(),

      routes: {
        "/login": (context) => const LoginScreenAjeng(),
        "/register": (context) => const RegisterScreenAjeng(),
        "/home": (context) => HomeScreenAjeng(),
        "/cart": (context) => const CartScreenAjeng(),
      },
    );
  }
}