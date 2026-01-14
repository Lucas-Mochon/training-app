import 'package:flutter/material.dart';
import 'package:frontend/store/page/user/profil_store.dart';
import 'package:provider/provider.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/store/auth_store.dart';

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

  Future<void> handleLogin() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    final userService = UserService(authStore: AuthStore());

    try {
      final response = await userService.login({
        'email': emailController.text,
        'password': passwordController.text,
      });

      final data = response['data'];
      final accessToken = data['accessToken'];
      final refreshToken = data['user']?['refreshToken'];
      final user = data['user'];

      if (accessToken != null) {
        await context.read<AuthStore>().setToken(accessToken);
      }

      if (refreshToken != null) {
        await context.read<AuthStore>().setRefreshToken(refreshToken);
      }

      ProfileStore(authStore: AuthStore()).user = user;

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login réussi 🎉')));
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
