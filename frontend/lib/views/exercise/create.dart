import 'package:flutter/material.dart';
import 'package:frontend/constants/enum/exercise_difficulty_enum.dart';
import 'package:frontend/constants/enum/exercise_equipment_enum.dart';
import 'package:frontend/store/page/exercise/exercise_store.dart';
import 'package:provider/provider.dart';

class ExerciseCreatePage extends StatefulWidget {
  const ExerciseCreatePage({super.key});

  @override
  State<ExerciseCreatePage> createState() => _ExerciseCreatePageState();
}

class _ExerciseCreatePageState extends State<ExerciseCreatePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  bool _isSubmitting = false;
  String? _error;

  Exercisedifficulty _selectedDifficulty = Exercisedifficulty.medium;
  ExerciseEquipment _selectedEquipment = ExerciseEquipment.bodyweight;
  bool _isCompound = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _validateInputs() {
    if (_nameController.text.isEmpty) {
      return 'Veuillez entrer le nom de l\'exercice';
    }

    if (_nameController.text.length < 3) {
      return 'Le nom doit contenir au moins 3 caractères';
    }

    return null;
  }

  String _getErrorMessage(String error) {
    if (error.contains('already exists')) {
      return 'Cet exercice existe déjà';
    }
    if (error.contains('network') || error.contains('Connection')) {
      return 'Erreur de connexion. Vérifiez votre internet';
    }
    if (error.contains('timeout')) {
      return 'La requête a expiré. Réessayez';
    }
    return error;
  }

  Future<void> _handleCreate() async {
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

    try {
      await context.read<ExerciseStore>().create(
        _nameController.text,
        _selectedDifficulty,
        _isCompound,
        _selectedEquipment,
        _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Exercice créé avec succès !'),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.pop(context);
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
      appBar: AppBar(title: const Text('Créer un exercice'), elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nouvel exercice',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Ajoutez un nouvel exercice à la base de données',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),

              const SizedBox(height: 32),

              Text(
                'Nom de l\'exercice',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nameController,
                enabled: !_isSubmitting,
                decoration: InputDecoration(
                  hintText: 'Ex: Développé couché',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.fitness_center),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Description (optionnel)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                enabled: !_isSubmitting,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Décrivez l\'exercice...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.description),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Difficulté',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[700]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<Exercisedifficulty>(
                  value: _selectedDifficulty,
                  isExpanded: true,
                  underline: const SizedBox(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  items: Exercisedifficulty.values.map((difficulty) {
                    return DropdownMenuItem(
                      value: difficulty,
                      child: Text(_getDifficultyLabel(difficulty)),
                    );
                  }).toList(),
                  onChanged: _isSubmitting
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() => _selectedDifficulty = value);
                          }
                        },
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Équipement',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[700]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<ExerciseEquipment>(
                  value: _selectedEquipment,
                  isExpanded: true,
                  underline: const SizedBox(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  items: ExerciseEquipment.values.map((equipment) {
                    return DropdownMenuItem(
                      value: equipment,
                      child: Text(_getEquipmentLabel(equipment)),
                    );
                  }).toList(),
                  onChanged: _isSubmitting
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() => _selectedEquipment = value);
                          }
                        },
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Type d\'exercice',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[700]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.fitness_center),
                        const SizedBox(width: 12),
                        Text(
                          _isCompound
                              ? 'Exercice composé'
                              : 'Exercice d\'isolation',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Switch(
                      value: _isCompound,
                      onChanged: _isSubmitting
                          ? null
                          : (value) {
                              setState(() => _isCompound = value);
                            },
                    ),
                  ],
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
                              'Erreur',
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
                  onPressed: _isSubmitting ? null : _handleCreate,
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
                      : const Icon(Icons.add),
                  label: Text(
                    _isSubmitting
                        ? 'Création en cours...'
                        : 'Créer l\'exercice',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Annuler'),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _getDifficultyLabel(Exercisedifficulty difficulty) {
    switch (difficulty) {
      case Exercisedifficulty.easy:
        return 'Facile';
      case Exercisedifficulty.medium:
        return 'Moyen';
      case Exercisedifficulty.hard:
        return 'Difficile';
    }
  }

  String _getEquipmentLabel(ExerciseEquipment equipment) {
    switch (equipment) {
      case ExerciseEquipment.barbell:
        return 'Barre';
      case ExerciseEquipment.dumbbell:
        return 'Haltère';
      case ExerciseEquipment.bodyweight:
        return 'Poids du corps';
      case ExerciseEquipment.machine:
        return 'Machine';
    }
  }
}
