import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:agro_sales/src/models/model_user.dart';
import 'package:agro_sales/src/pages/auth/sign_in_screen.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  ModelUser? _currentUser;

  ModelUser? get currentUser => _currentUser;

  Future<void> signUp({
    required String email,
    required String password,
    required String nome,
    required String number,
    required String cpf,
    required String endereco,
    required bool isSeller,
  }) async {
    isLoading.value = true;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      ModelUser user = ModelUser(
        userUid: uid,
        name: nome,
        email: email,
        password: password,
        number: number,
        cpf: cpf,
        endereco: endereco,
        isSeller: isSeller,
      );

      await db.collection('usuarios').doc(uid).set(user.toMap());

      Get.snackbar(
        'Sucesso',
        'Cadastro realizado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAll(() => const SignInScreen());
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível realizar o cadastro.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUserData() async {
    try {
      final User? currentUserAuth = auth.currentUser;

      if (currentUserAuth == null) {
        throw Exception("Usuário não está logado.");
      }

      DocumentSnapshot userDoc =
          await db.collection("usuarios").doc(currentUserAuth.uid).get();

      if (userDoc.exists) {
        _currentUser =
            ModelUser.fromJson(userDoc.data() as Map<String, dynamic>);
      } else {
        throw Exception("Dados do usuário não encontrados.");
      }
    } catch (e) {
      Get.snackbar(
        "Erro",
        "Erro ao carregar os dados do usuário.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
      _currentUser = null;
      Get.offAll(() => const SignInScreen());
    } catch (e) {
      Get.snackbar(
        "Erro",
        "Erro ao fazer logout.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
