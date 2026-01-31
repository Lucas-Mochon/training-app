import 'package:flutter/material.dart';
import 'package:frontend/constants/enum/user_goal_enum.dart';
import 'package:frontend/constants/enum/user_level_enum.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/store/auth_store.dart';
import 'package:frontend/store/page/user/profil_store.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool _isSubmitting = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _error;

  UserLevel _selectedLevel = UserLevel.beginner;
  UserGoal _selectedGoal = UserGoal.strength;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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

    if (!_isStrongPassword(_passwordController.text)) {
      return 'Le mot de passe doit contenir au moins une majuscule, une minuscule, un chiffre et un caractère spécial';
    }

    if (_confirmPasswordController.text.isEmpty) {
      return 'Veuillez confirmer votre mot de passe';
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      return 'Les mots de passe ne correspondent pas';
    }

    return null;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool _isStrongPassword(String password) {
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return hasUppercase && hasLowercase && hasDigits && hasSpecialChar;
  }

  String _getErrorMessage(String error) {
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
    if (error.contains('timeout')) {
      return 'La requête a expiré. Réessayez';
    }
    return error;
  }

  Future<void> _handleRegister() async {
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

    final userService = UserService(authStore: AuthStore());

    try {
      final response = await userService.register({
        'email': _emailController.text,
        'password': _passwordController.text,
        'level': _selectedLevel.value,
        'goal': _selectedGoal.value,
      });

      final data = response['data'];
      final accessToken = data['accessToken'];
      final refreshToken = data['user']?['refreshToken'];
      final role = data['user']?['role'];
      final user = data['user'];

      if (accessToken == null) {
        throw Exception('Token d\'accès manquant');
      }

      if (role != null) {
        await context.read<AuthStore>().setRole(role);
      } else {
        await context.read<AuthStore>().setRole('user');
      }

      await context.read<AuthStore>().setToken(accessToken);

      if (refreshToken != null) {
        await context.read<AuthStore>().setRefreshToken(refreshToken);
      }
      ProfileStore(authStore: context.read<AuthStore>()).user = user;

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inscription réussie !'),
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
      appBar: AppBar(title: const Text('Inscription'), elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Créer un compte',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Rejoignez-nous pour commencer votre entraînement',
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
              const SizedBox(height: 8),
              Text(
                'Au moins 8 caractères (majuscule, minuscule, chiffre, caractère spécial)',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),

              const SizedBox(height: 24),

              Text(
                'Confirmer le mot de passe',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _confirmPasswordController,
                enabled: !_isSubmitting,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  hintText: 'Confirmez votre mot de passe',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: _isSubmitting
                        ? null
                        : () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Niveau d\'expérience',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[700]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<UserLevel>(
                  value: _selectedLevel,
                  isExpanded: true,
                  underline: const SizedBox(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  items: UserLevel.values.map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text(_getLevelLabel(level)),
                    );
                  }).toList(),
                  onChanged: _isSubmitting
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() => _selectedLevel = value);
                          }
                        },
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Objectif d\'entraînement',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[700]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<UserGoal>(
                  value: _selectedGoal,
                  isExpanded: true,
                  underline: const SizedBox(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  items: UserGoal.values.map((goal) {
                    return DropdownMenuItem(
                      value: goal,
                      child: Text(_getGoalLabel(goal)),
                    );
                  }).toList(),
                  onChanged: _isSubmitting
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() => _selectedGoal = value);
                          }
                        },
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
                              'Erreur d\'inscription',
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
                  onPressed: _isSubmitting ? null : _handleRegister,
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
                      : const Icon(Icons.person_add),
                  label: Text(
                    _isSubmitting ? 'Inscription en cours...' : 'S\'inscrire',
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
                      'Vous avez déjà un compte ? ',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    TextButton(
                      onPressed: _isSubmitting
                          ? null
                          : () {
                              Navigator.of(context).pop();
                            },
                      child: const Text('Se connecter'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _getLevelLabel(UserLevel level) {
    switch (level) {
      case UserLevel.beginner:
        return 'Débutant';
      case UserLevel.intermediate:
        return 'Intermédiaire';
      case UserLevel.advanced:
        return 'Avancé';
    }
  }

  String _getGoalLabel(UserGoal goal) {
    switch (goal) {
      case UserGoal.strength:
        return 'Force';
      case UserGoal.hypertrophy:
        return 'Hypertrophie';
      case UserGoal.cut:
        return 'Sèche';
    }
  }
}
