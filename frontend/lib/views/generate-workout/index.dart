import 'package:flutter/material.dart';
import 'package:frontend/store/page/user/profil_store.dart';
import 'package:frontend/store/page/workout/workout_store.dart';
import 'package:frontend/store/muscle_group_store.dart';
import 'package:provider/provider.dart';

class GenerateWorkoutPage extends StatefulWidget {
  const GenerateWorkoutPage({super.key});

  @override
  State<GenerateWorkoutPage> createState() => _GenerateWorkoutPageState();
}

class _GenerateWorkoutPageState extends State<GenerateWorkoutPage> {
  late final TextEditingController _descriptionController;
  late final TextEditingController _durationController;

  String? _selectedMuscleGroupName;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _durationController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MuscleGroupStore>().getList();
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_descriptionController.text.isEmpty) {
      _showError('Veuillez entrer une description');
      return;
    }

    if (_durationController.text.isEmpty) {
      _showError('Veuillez entrer une durée');
      return;
    }

    if (_selectedMuscleGroupName == null) {
      _showError('Veuillez sélectionner un groupe musculaire');
      return;
    }

    final duration = int.tryParse(_durationController.text);
    if (duration == null || duration <= 0) {
      _showError('La durée doit être un nombre positif');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final profileStore = context.read<ProfileStore>();
      final userId = profileStore.user?['id'] as String?;

      if (userId == null) {
        throw Exception('ID utilisateur non trouvé');
      }

      await context.read<WorkoutStore>().generateWorkout(
        userId,
        duration,
        _descriptionController.text,
        _selectedMuscleGroupName!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Entraînement généré avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        _showError('Erreur : $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Générer un entraînement'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Consumer<MuscleGroupStore>(
          builder: (context, muscleGroupStore, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Générer un entraînement',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText:
                          'Ex: Entraînement intense avec focus sur la force...',
                      prefixIcon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Durée (minutes)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Ex: 45',
                      prefixIcon: const Icon(Icons.timer),
                      suffixText: 'min',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Groupe musculaire',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),

                  if (muscleGroupStore.isLoading)
                    _loadingBox()
                  else if (muscleGroupStore.error != null)
                    _errorBox(muscleGroupStore.error!)
                  else
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[700]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedMuscleGroupName,
                        isExpanded: true,
                        underline: const SizedBox(),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        hint: const Text('Sélectionner un groupe musculaire'),
                        items: (muscleGroupStore.muscleGroups ?? [])
                            .map(
                              (group) => DropdownMenuItem<String>(
                                value: group.name,
                                child: Text(group.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedMuscleGroupName = value;
                          });
                        },
                      ),
                    ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _handleSubmit,
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
                          : const Icon(Icons.auto_awesome),
                      label: Text(
                        _isSubmitting
                            ? 'Génération en cours...'
                            : 'Générer l\'entraînement',
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
                      child: const Text('Annuler'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _loadingBox() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey[700]!),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Center(child: CircularProgressIndicator()),
  );

  Widget _errorBox(String error) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.red),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text('Erreur : $error', style: const TextStyle(color: Colors.red)),
  );
}
