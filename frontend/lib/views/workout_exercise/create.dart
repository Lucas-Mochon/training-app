import 'package:flutter/material.dart';
import 'package:frontend/store/page/exercise/exercise_store.dart';
import 'package:frontend/store/page/workout_exercise/workout_exercise_store.dart';
import 'package:provider/provider.dart';

class WorkoutExerciseCreatePage extends StatefulWidget {
  final String workoutId;

  const WorkoutExerciseCreatePage({super.key, required this.workoutId});

  @override
  State<WorkoutExerciseCreatePage> createState() =>
      _WorkoutExerciseCreatePageState();
}

class _WorkoutExerciseCreatePageState extends State<WorkoutExerciseCreatePage> {
  late final TextEditingController _setsController;
  late final TextEditingController _repsController;
  late final TextEditingController _restSecondsController;
  late final TextEditingController _orderIndexController;

  int? _selectedExerciseId;
  bool _isSubmitting = false;
  bool _isLoadingExercises = false;

  @override
  void initState() {
    super.initState();
    _setsController = TextEditingController();
    _repsController = TextEditingController();
    _restSecondsController = TextEditingController();
    _orderIndexController = TextEditingController();
    _loadExercises();
  }

  @override
  void dispose() {
    _setsController.dispose();
    _repsController.dispose();
    _restSecondsController.dispose();
    _orderIndexController.dispose();
    super.dispose();
  }

  Future<void> _loadExercises() async {
    setState(() => _isLoadingExercises = true);
    try {
      await context.read<ExerciseStore>().getList();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement des exercices : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingExercises = false);
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (_selectedExerciseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un exercice')),
      );
      return;
    }

    // Validation des champs optionnels
    int? sets;
    int? restSeconds;
    int? orderIndex;

    if (_setsController.text.isNotEmpty) {
      sets = int.tryParse(_setsController.text);
      if (sets == null || sets <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Le nombre de séries doit être un nombre positif'),
          ),
        );
        return;
      }
    }

    if (_restSecondsController.text.isNotEmpty) {
      restSeconds = int.tryParse(_restSecondsController.text);
      if (restSeconds == null || restSeconds < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Le repos doit être un nombre positif')),
        );
        return;
      }
    }

    if (_orderIndexController.text.isNotEmpty) {
      orderIndex = int.tryParse(_orderIndexController.text);
      if (orderIndex == null || orderIndex < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('L\'ordre doit être un nombre positif')),
        );
        return;
      }
    }

    setState(() => _isSubmitting = true);

    try {
      await context.read<WorkoutExerciseStore>().create(
        widget.workoutId,
        _selectedExerciseId!,
        sets,
        _repsController.text.isNotEmpty ? _repsController.text : null,
        restSeconds,
        orderIndex,
        context,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exercice ajouté avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un exercice'), elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nouvel Exercice',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),

              // Dropdown Exercices
              Text('Exercice', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              _isLoadingExercises
                  ? const Center(child: CircularProgressIndicator())
                  : Consumer<ExerciseStore>(
                      builder: (context, exerciseStore, _) {
                        if (exerciseStore.exercises == null ||
                            exerciseStore.exercises!.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[700]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Aucun exercice disponible',
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }

                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[700]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<int>(
                            value: _selectedExerciseId,
                            isExpanded: true,
                            underline: const SizedBox(),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            hint: const Text('Sélectionner un exercice'),
                            items: exerciseStore.exercises!.map((exercise) {
                              return DropdownMenuItem(
                                value: exercise.id,
                                child: Text(exercise.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() => _selectedExerciseId = value);
                            },
                          ),
                        );
                      },
                    ),

              const SizedBox(height: 24),

              // Séries
              Text(
                'Séries (optionnel)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _setsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Ex: 3',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.repeat),
                ),
              ),

              const SizedBox(height: 24),

              // Répétitions
              Text(
                'Répétitions (optionnel)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _repsController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Ex: 10-12',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.fitness_center),
                ),
              ),

              const SizedBox(height: 24),

              // Repos
              Text(
                'Repos (secondes, optionnel)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _restSecondsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Ex: 60',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.schedule),
                  suffixText: 's',
                ),
              ),

              const SizedBox(height: 24),

              // Ordre
              Text(
                'Ordre (optionnel)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _orderIndexController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Ex: 1',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.sort),
                ),
              ),

              const SizedBox(height: 32),

              // Bouton Ajouter
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add),
                  label: Text(
                    _isSubmitting ? 'Ajout en cours...' : 'Ajouter l\'exercice',
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
            ],
          ),
        ),
      ),
    );
  }
}
