import 'package:flutter/material.dart';
import 'package:frontend/store/page/user/profil_store.dart';
import 'package:frontend/views/user/register.dart';
import 'package:provider/provider.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/store/auth_store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  bool _isSubmitting = false;
  bool _obscurePassword = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  String? _validateInputs() {
    if (_emailController.text.isEmpty) {
      return 'Veuillez entrer votre email';
    }

    if (!_isValidEmail(_emailController.text)) {
      return 'Veuillez entrer un email valide';
    }

    if (_passwordController.text.isEmpty) {
      return 'Veuillez entrer votre mot de passe';
    }

    if (_passwordController.text.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }

    return null;
  }

  String _getErrorMessage(String error) {
    if (error.contains('Invalid credentials') ||
        error.contains('not found') ||
        error.contains('401')) {
      return 'Email ou mot de passe incorrect';
    }
    if (error.contains('already exists')) {
      return 'Cet email est déjà utilisé';
    }
    if (error.contains('Invalid email')) {
      return 'Format d\'email invalide';
    }
    if (error.contains('Password')) {
      return 'Le mot de passe ne respecte pas les critères de sécurité';
    }
    if (error.contains('network') || error.contains('Connection')) {
      return 'Erreur de connexion. Vérifiez votre internet';
    }
    if (error.contains('timeout') || error.contains('TimeoutException')) {
      return 'La requête a expiré. Réessayez';
    }
    if (error.contains('SocketException')) {
      return 'Impossible de se connecter au serveur';
    }
    if (error.contains('FormatException')) {
      return 'Erreur lors du traitement de la réponse du serveur';
    }
    return error;
  }

  Future<void> _handleLogin() async {
    final validationError = _validateInputs();
    if (validationError != null) {
      setState(() => _error = validationError);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    final userService = UserService(authStore: context.read<AuthStore>());

    try {
      final response = await userService.login({
        'email': _emailController.text,
        'password': _passwordController.text,
      });

      final data = response['data'];
      final accessToken = data['accessToken'];
      final refreshToken = data['user']?['refreshToken'];
      final role = data['user']?['role'];
      final user = data['user'];

      if (accessToken == null) {
        throw Exception('Token d\'accès manquant');
      }

      await context.read<AuthStore>().setToken(accessToken);

      if (role != null) {
        await context.read<AuthStore>().setRole(role);
      } else {
        await context.read<AuthStore>().setRole('user');
      }

      if (refreshToken != null) {
        await context.read<AuthStore>().setRefreshToken(refreshToken);
      }

      ProfileStore(authStore: context.read<AuthStore>()).user = user;

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connexion réussie !'),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.of(context).pop();
      }
    } on FormatException catch (e) {
      final errorMsg = _getErrorMessage(e.toString());
      setState(() => _error = errorMsg);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
        );
      }
    } on Exception catch (e) {
      final errorMsg = _getErrorMessage(e.toString());
      setState(() => _error = errorMsg);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      final errorMsg = _getErrorMessage(e.toString());
      setState(() => _error = errorMsg);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion'), elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Se connecter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Accédez à votre compte pour continuer',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),

              const SizedBox(height: 32),

              Text('Email', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              TextField(
                controller: _emailController,
                enabled: !_isSubmitting,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Entrez votre email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.email),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Mot de passe',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                enabled: !_isSubmitting,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Entrez votre mot de passe',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: _isSubmitting
                        ? null
                        : () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Erreur de connexion',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _error!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _handleLogin,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Icon(Icons.login),
                  label: Text(
                    _isSubmitting ? 'Connexion en cours...' : 'Se connecter',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Pas encore de compte ? ',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    TextButton(
                      onPressed: _isSubmitting
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterPage(),
                                ),
                              );
                            },
                      child: const Text('S\'inscrire'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
