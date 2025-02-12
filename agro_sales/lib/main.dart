import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Importando GetX 
import 'package:agro_sales/src/pages/auth/sign_in_screen.dart';
import 'package:agro_sales/src/Controller/controller.dart'; // Importando o AuthController

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Inicialização do Firebase
  await Firebase.initializeApp(); // Inicialização do Firebase

  // Registra o AuthController no GetXA
  Get.put<AuthController>(AuthController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // Alterado para GetMaterialApp
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white.withAlpha(190),
      ),
      debugShowCheckedModeBanner: false,
      home: const SignInScreen(),
    );
  }
}
