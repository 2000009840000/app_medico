import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class CadastroScreen extends StatefulWidget {
  CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;

  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final cpfController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  Future<void> salvarUsuario() async {
    await FirebaseFirestore.instance.collection('usuarios').add({
      'nome': nomeController.text.trim(),
      'email': emailController.text.trim(),
      'cpf': cpfController.text.trim(),
      'criadoEm': Timestamp.now(),
    });
  }

  Future<void> _criarConta() async {
    if (nomeController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        cpfController.text.trim().isEmpty ||
        senhaController.text.trim().isEmpty ||
        confirmarSenhaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Preencha todos os campos.')));
      return;
    }

    if (senhaController.text != confirmarSenhaController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('As senhas não coincidem.')));
      return;
    }

    try {
      await salvarUsuario();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Conta criada com sucesso!')));

      nomeController.clear();
      emailController.clear();
      cpfController.clear();
      senhaController.clear();
      confirmarSenhaController.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar usuário: $e')));
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    cpfController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0C447C),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 64, bottom: 24),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Icon(
                      Icons.favorite_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    'VidaPlena',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'A sua jornada para uma vida plena',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              padding: EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Criar conta',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Preencha os dados para se cadastrar',
                    style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                  ),
                  SizedBox(height: 24),

                  _buildLabel('Nome completo'),
                  SizedBox(height: 6),
                  _buildInput(
                    hint: 'Seu nome completo',
                    icon: Icons.person_outline,
                    controller: nomeController,
                  ),
                  SizedBox(height: 14),

                  _buildLabel('Email'),
                  SizedBox(height: 6),
                  _buildInput(
                    hint: 'seu@email.com',
                    icon: Icons.email_outlined,
                    controller: emailController,
                  ),
                  SizedBox(height: 14),

                  _buildLabel('CPF'),
                  SizedBox(height: 6),
                  _buildInput(
                    hint: '000.000.000-00',
                    icon: Icons.badge_outlined,
                    controller: cpfController,
                  ),
                  SizedBox(height: 14),

                  _buildLabel('Senha'),
                  SizedBox(height: 6),
                  TextField(
                    controller: senhaController,
                    obscureText: !_senhaVisivel,
                    decoration:
                        _inputDecoration(
                          hint: 'Mínimo 8 caracteres',
                          icon: Icons.lock_outline,
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _senhaVisivel
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _senhaVisivel = !_senhaVisivel;
                              });
                            },
                          ),
                        ),
                  ),
                  SizedBox(height: 14),

                  _buildLabel('Confirmar senha'),
                  SizedBox(height: 6),
                  TextField(
                    controller: confirmarSenhaController,
                    obscureText: !_confirmarSenhaVisivel,
                    decoration:
                        _inputDecoration(
                          hint: 'Repita sua senha',
                          icon: Icons.lock_outline,
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _confirmarSenhaVisivel
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _confirmarSenhaVisivel =
                                    !_confirmarSenhaVisivel;
                              });
                            },
                          ),
                        ),
                  ),
                  SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _criarConta,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0C447C),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Criar conta',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Já tem conta? ',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Entrar',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: const Color(0xFF185FA5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: Colors.grey,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildInput({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      decoration: _inputDecoration(hint: hint, icon: icon),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(fontSize: 13, color: Colors.grey[400]),
      prefixIcon: Icon(icon, size: 18, color: Colors.grey),
      filled: true,
      fillColor: Color(0xFFF5F8FF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFF0C447C)),
      ),
    );
  }
}
