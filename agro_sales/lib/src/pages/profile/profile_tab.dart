import 'package:agro_sales/src/pages/register/register.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agro_sales/src/pages/auth/Components/Custom_text_field.dart';
import 'package:flutter/services.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  Future<Map<String, dynamic>?> fetchUserData() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception("Usuário não está logado.");
    }

    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("usuarios")
        .doc(currentUser.uid)
        .get();

    if (!userDoc.exists) {
      throw Exception("Dados do usuário não encontrados.");
    }

    return userDoc.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil do Usuário',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFB52A2A),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            tooltip: 'Sair',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                    'Sair',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: const Text('Você tem certeza que deseja sair?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await FirebaseAuth.instance.signOut();
                        SystemNavigator.pop();
                      },
                      child: const Text(
                        'Sair',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFE0E0E0),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: fetchUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Erro ao carregar os dados do usuário: ${snapshot.error}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            final userData = snapshot.data;

            if (userData == null) {
              return const Center(
                child: Text(
                  "Dados do usuário não encontrados.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final bool isSeller = userData['isSeller'] == true;

            return ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade700, width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFieldConfig(
                        icon: Icons.email,
                        label: 'Email',
                        initialValue: userData['email'] ?? 'Não informado',
                        readOnly: true,
                        labelStyle: const TextStyle(color: Colors.black),
                        textStyle: const TextStyle(color: Colors.black),
                      ),
                      CustomTextFieldConfig(
                        icon: Icons.person,
                        label: 'Nome',
                        initialValue: userData['name'] ?? 'Não informado',
                        readOnly: true,
                        labelStyle: const TextStyle(color: Colors.black),
                        textStyle: const TextStyle(color: Colors.black),
                      ),
                      CustomTextFieldConfig(
                        icon: Icons.phone,
                        label: 'Celular',
                        initialValue: userData['number'] ?? 'Não informado',
                        readOnly: true,
                        labelStyle: const TextStyle(color: Colors.black),
                        textStyle: const TextStyle(color: Colors.black),
                      ),
                      CustomTextFieldConfig(
                        icon: Icons.file_copy,
                        label: 'CPF',
                        initialValue: userData['cpf'] ?? 'Não informado',
                        readOnly: true,
                        isSecret: true,
                        labelStyle: const TextStyle(color: Colors.black),
                        textStyle: const TextStyle(color: Colors.black),
                      ),
                      CustomTextFieldConfig(
                        icon: Icons.location_on,
                        label: 'Endereço',
                        initialValue: userData['endereco'] ?? 'Não informado',
                        readOnly: true,
                        labelStyle: const TextStyle(color: Colors.black),
                        textStyle: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tipo de Usuário',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.person_outline,
                          color: isSeller ? Colors.grey : Colors.red,
                        ),
                        title: const Text(
                          'Comprador',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        trailing: Radio<String>(
                          value: 'comprador',
                          groupValue: isSeller ? 'vendedor' : 'comprador',
                          onChanged: null,
                          activeColor: Colors.red,
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.store_mall_directory,
                          color: isSeller ? Colors.red : Colors.grey,
                        ),
                        title: const Text(
                          'Vendedor',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        trailing: Radio<String>(
                          value: 'vendedor',
                          groupValue: isSeller ? 'vendedor' : 'comprador',
                          onChanged: null,
                          activeColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSeller)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Register(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('CADASTRAR VENDA'),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
