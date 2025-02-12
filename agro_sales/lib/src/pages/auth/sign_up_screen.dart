import 'package:flutter/material.dart'; 
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:agro_sales/src/Controller/controller.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isTermsAccepted = false;
  bool isLGPDConsentGiven = false;

  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();
  final TextEditingController _controllerNumber = TextEditingController();
  final TextEditingController _controllerCpf = TextEditingController();
  final TextEditingController _controllerEndereco = TextEditingController();

  final cpfformatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  final phoneformatter = MaskTextInputFormatter(
    mask: '## # ####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  String? userType;
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    _controllerNome.addListener(_validateForm);
    _controllerEmail.addListener(_validateForm);
    _controllerSenha.addListener(_validateForm);
    _controllerNumber.addListener(_validateForm);
    _controllerCpf.addListener(_validateForm);
    _controllerEndereco.addListener(_validateForm);
  }

  @override
  void dispose() {
    _controllerNome.dispose();
    _controllerEmail.dispose();
    _controllerSenha.dispose();
    _controllerNumber.dispose();
    _controllerCpf.dispose();
    _controllerEndereco.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      isFormValid = _controllerNome.text.isNotEmpty &&
          _controllerEmail.text.isNotEmpty &&
          _controllerSenha.text.isNotEmpty &&
          _controllerNumber.text.isNotEmpty &&
          _controllerCpf.text.isNotEmpty &&
          _controllerEndereco.text.isNotEmpty &&
          userType != null &&
          isTermsAccepted &&
          isLGPDConsentGiven;
    });
  }

  Widget _buildTextField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    bool isSecret = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: isSecret,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.red),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }

  void _showLGPDInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Informações sobre a LGPD'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'A Lei Geral de Proteção de Dados (LGPD) visa proteger os direitos fundamentais de liberdade e de privacidade, e o livre desenvolvimento da personalidade da pessoa natural. Ao cadastrar-se neste aplicativo, você concorda com os seguintes pontos:',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  '1. Coleta de Dados Pessoais: O app coleta dados como nome, e-mail, telefone, CPF e outros dados relacionados ao cadastro.',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  '2. Finalidade: Seus dados serão utilizados para o processo de cadastro e compra/venda de gado, incluindo a exibição de informações no app.',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  '3. Compartilhamento: Os dados podem ser compartilhados com parceiros e fornecedores que prestem serviços relacionados ao funcionamento do app.',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  '4. Direitos do Usuário: Você tem o direito de acessar, corrigir, excluir ou pedir a portabilidade dos seus dados pessoais.',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  '5. Consentimento: Ao continuar com o cadastro, você concorda com o tratamento dos seus dados pessoais conforme descrito nesta política.',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fechar'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'Cadastro de Usuário',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade700, width: 2),
                  ),
                  child: Column(
                    children: [
                      _buildTextField(
                        icon: Icons.email,
                        label: 'Email',
                        controller: _controllerEmail,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'O campo email é obrigatório';
                          }
                          if (!value.contains('@')) {
                            return 'Digite um email válido';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        icon: Icons.lock,
                        label: 'Senha',
                        controller: _controllerSenha,
                        isSecret: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'O campo senha é obrigatório';
                          }
                          if (value.length < 6) {
                            return 'A senha deve ter pelo menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        icon: Icons.person,
                        label: 'Nome',
                        controller: _controllerNome,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'O campo nome é obrigatório';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        icon: Icons.phone,
                        label: 'Celular',
                        controller: _controllerNumber,
                        inputFormatters: [phoneformatter],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'O campo celular é obrigatório';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        icon: Icons.file_copy,
                        label: 'CPF',
                        controller: _controllerCpf,
                        inputFormatters: [cpfformatter],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'O campo CPF é obrigatório';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        icon: Icons.location_on,
                        label: 'Endereço',
                        controller: _controllerEndereco,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'O campo endereço é obrigatório';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Selecione o tipo de usuário:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                RadioListTile<String>(
                  title: const Text('Comprador'),
                  value: 'comprador',
                  groupValue: userType,
                  onChanged: (value) {
                    setState(() {
                      userType = value;
                      _validateForm();
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Vendedor'),
                  value: 'vendedor',
                  groupValue: userType,
                  onChanged: (value) {
                    setState(() {
                      userType = value;
                      _validateForm();
                    });
                  },
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text(
                    'Eu aceito os Termos e Condições',
                    style: TextStyle(fontSize: 16),
                  ),
                  value: isTermsAccepted,
                  onChanged: (bool? newValue) {
                    setState(() {
                      isTermsAccepted = newValue ?? false;
                      _validateForm();
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text(
                    'Eu concordo com a coleta e tratamento dos meus dados pessoais de acordo com a LGPD.',
                    style: TextStyle(fontSize: 16),
                  ),
                  value: isLGPDConsentGiven,
                  onChanged: (bool? newValue) {
                    setState(() {
                      isLGPDConsentGiven = newValue ?? false;
                      _validateForm();
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _showLGPDInfo,
                  child: const Text(
                    'Saiba mais sobre a LGPD',
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 16),
                GetX<AuthController>(builder: (authController) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isFormValid
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                authController.signUp(
                                  email: _controllerEmail.text,
                                  password: _controllerSenha.text,
                                  nome: _controllerNome.text,
                                  number: _controllerNumber.text,
                                  cpf: _controllerCpf.text,
                                  endereco: _controllerEndereco.text,
                                  isSeller: userType == 'vendedor',
                                );
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: authController.isLoading.value
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Cadastrar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
