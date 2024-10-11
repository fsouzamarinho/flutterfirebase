import 'package:firebase01/Data/spUser.dart';
import 'package:firebase01/userprofile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      // Realiza o login com Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );


      // Obter o UID do usuário autenticado
    String uid = userCredential.user!.uid;

    // Salvar o UID usando a função setUid do spUser
    await SPUser.setUid(uid);

    // Gravar o UID na coleção 'profissionais'
    await _firestore.collection('profissionais').doc(uid).set({
      'codigoprofissional': uid, // Exemplo de outro campo
    });

      // Após o login, navega para a tela que exibe os dados do usuário
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => UserProfileScreen(userCredential.user!),
        ),
      );
    } catch (e) {
      print("Erro no login: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao fazer login')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
