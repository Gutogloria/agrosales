import 'package:flutter/material.dart';
import 'package:agro_sales/src/pages/auth/Components/Custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ForgotPasswordDialog extends StatelessWidget {
  final emailController = TextEditingController();

  ForgotPasswordDialog({
    required String email,
    Key? key,
  }) : super(key: key) {
    emailController.text = email;
  }

  @override
  Widget build(BuildContext context) {
    String? errorMessage;

    return StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Recuperação de senha',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 10,
                        bottom: 20,
                      ),
                      child: Text(
                        'Digite seu email para recuperar sua senha',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    CustomTextFieldConfig(
                      controller: emailController,
                      icon: Icons.email,
                      label: 'Email',
                      validator: (email) {
                        if (email == null || email.isEmpty) {
                          return 'Por favor, insira um e-mail.';
                        }
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegex.hasMatch(email)) {
                          return 'Por favor, insira um e-mail válido.';
                        }
                        return null;
                      },
                    ),
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: const BorderSide(
                          width: 2,
                          color: Colors.green,
                        ),
                      ),
                      onPressed: () async {
                        final email = emailController.text.trim();

                        if (email.isEmpty) {
                          setState(() {
                            errorMessage = 'Por favor, insira um e-mail.';
                          });
                          return;
                        }

                        try {
                          final querySnapshot = await FirebaseFirestore.instance
                              .collection('usuarios')
                              .where('email', isEqualTo: email)
                              .get();

                          if (querySnapshot.docs.isEmpty) {
                            setState(() {
                              errorMessage = 'Email não cadastrado.';
                            });
                            return;
                          }

                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: email);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'E-mail de recuperação enviado. Verifique sua caixa de entrada.'),
                              backgroundColor: Colors.green,
                            ),
                          );

                          Navigator.of(context).pop();
                        } catch (error) {
                          setState(() {
                            errorMessage =
                                'Erro ao enviar e-mail de recuperação. Tente novamente.';
                          });
                        }
                      },
                      child: const Text(
                        'Recuperar',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
