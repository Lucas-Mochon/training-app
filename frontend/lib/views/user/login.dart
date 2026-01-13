import 'package:flutter/material.dart';
import 'package:frontend/services/user_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String? error;

  // Ton token sera stocké ici après login
  String? token;

  void handleLogin() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    final userService = UserService(token: ''); // token vide pour login

    try {
      final response = await userService.login({
        'email': emailController.text,
        'password': passwordController.text,
      });

      // Supposons que ton API renvoie { token: "..." }
      token = response['token'];
      print('Login réussi, token = $token');

      // Tu peux naviguer vers une autre page maintenant
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login réussi !')));
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
            ),
            const SizedBox(height: 24),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: handleLogin,
                    child: const Text('Se connecter'),
                  ),
            if (error != null) ...[
              const SizedBox(height: 16),
              Text(error!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
