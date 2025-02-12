import 'package:agro_sales/src/Controller/controller.dart';
import 'package:agro_sales/src/base/base_screen.dart';
import 'package:agro_sales/src/pages/auth/home/Components/Forgot_passworld_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agro_sales/src/pages/auth/Components/Custom_text_field.dart';
import 'package:agro_sales/src/pages/auth/sign_up_screen.dart';
import 'package:agro_sales/src/config/theme.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _verificarLogin();
  }

  Future<void> _verificarLogin() async {
    final User? usuario = auth.currentUser;
    if (usuario != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const BaseScreen(),
          ),
        );
      });
    }
  }

  Future<void> _login() async {
    final navigator = Navigator.of(context);
    try {
      await auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _senhaController.text,
      );
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (context) => const BaseScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        _showErrorDialog();
      } else {
        _showErrorDialog();
      }
    } catch (e) {
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Credenciais Incorretas'),
          content: const Text('As credenciais fornecidas estão incorretas. Tente novamente.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Tentar Novamente'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeOf = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ThemeApp.red,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: sizeOf.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: ThemeApp.red,
                    child: Padding(
                      padding: const EdgeInsets.all(50),
                      child: Image.asset(
                        'assets/logo.png',
                        height: sizeOf.height * 0.2,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 40,
                  ),
                  decoration: const BoxDecoration(
                    color: ThemeApp.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(45),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextFieldConfig(
                          icon: Icons.email,
                          label: 'Email',
                          controller: _emailController,
                          backgroundColor: Colors.white,
                          labelStyle: const TextStyle(color: Colors.black),
                          textStyle: const TextStyle(color: Colors.black),
                        ),
                        const SizedBox(height: 16),
                        CustomTextFieldConfig(
                          backgroundColor: Colors.white,
                          icon: Icons.lock,
                          label: 'Senha',
                          isSecret: true,
                          controller: _senhaController,
                          labelStyle: const TextStyle(color: Colors.black),
                          textStyle: const TextStyle(color: Colors.black),
                        ),
                        const SizedBox(height: 16),
                        GetX<AuthController>(
                          init: Get.put(AuthController()),
                          builder: (authController) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              onPressed: authController.isLoading.value
                                  ? null
                                  : () {
                                      FocusScope.of(context).unfocus();
                                      if (_formKey.currentState != null &&
                                          _formKey.currentState!.validate()) {
                                        _login();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Erro ao validar o formulário',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                              child: authController.isLoading.value
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      'Entrar',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                            );
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return ForgotPasswordDialog(
                                    email: _emailController.text,
                                  );
                                },
                              );
                            },
                            child: const Text(
                              'Esqueceu a Senha?',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.black.withAlpha(90),
                                  thickness: 2,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text('Ou'),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.black.withAlpha(90),
                                  thickness: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            side: const BorderSide(
                              width: 2,
                              color: Colors.black26,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (c) {
                                  return SignUpScreen();
                                },
                              ),
                            );
                          },
                          child: const Text(
                            'Criar conta',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
