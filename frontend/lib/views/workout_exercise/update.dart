import 'package:flutter/material.dart';
import 'package:frontend/store/page/exercise/exercise_store.dart';
import 'package:frontend/store/page/workout_exercise/workout_exercise_store.dart';
import 'package:provider/provider.dart';

class WorkoutExerciseUpdatePage extends StatefulWidget {
  final int workoutExerciseId;

  const WorkoutExerciseUpdatePage({super.key, required this.workoutExerciseId});

  @override
  State<WorkoutExerciseUpdatePage> createState() =>
      _WorkoutExerciseUpdatePageState();
}

class _WorkoutExerciseUpdatePageState extends State<WorkoutExerciseUpdatePage> {
  late final String exerciseName;
  late final TextEditingController _setsController;
  late final TextEditingController _repsController;
  late final TextEditingController _restSecondsController;
  late final TextEditingController _orderIndexController;

  bool _isSubmitting = false;
  bool _isLoadingData = false;

  @override
  void initState() {
    super.initState();
    _setsController = TextEditingController();
    _repsController = TextEditingController();
    _restSecondsController = TextEditingController();
    _orderIndexController = TextEditingController();
    _loadWorkoutExercise();
  }

  @override
  void dispose() {
    _setsController.dispose();
    _repsController.dispose();
    _restSecondsController.dispose();
    _orderIndexController.dispose();
    super.dispose();
  }

  Future<void> _loadWorkoutExercise() async {
    setState(() => _isLoadingData = true);
    try {
      await context.read<WorkoutExerciseStore>().getOne(
        widget.workoutExerciseId,
      );

      final workoutExercise = context
          .read<WorkoutExerciseStore>()
          .workoutExcercise;
      if (workoutExercise != null && mounted) {
        _setsController.text = workoutExercise.sets?.toString() ?? '';
        _repsController.text = workoutExercise.reps ?? '';
        _restSecondsController.text =
            workoutExercise.restSeconds?.toString() ?? '';
        _orderIndexController.text =
            workoutExercise.orderIndex?.toString() ?? '';
      }
      _loadExercice(workoutExercise?.exerciseId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingData = false);
      }
    }
  }

  Future<void> _loadExercice(int? exerciseId) async {
    try {
      if (exerciseId != null) {
        await context.read<ExerciseStore>().getOne(exerciseId);
        final exercise = context.read<ExerciseStore>().exercise;
        if (exercise != null && mounted) {
          exerciseName = exercise.name;
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingData = false);
      }
    }
  }

  Future<void> _handleSubmit() async {
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
      await context.read<WorkoutExerciseStore>().update(
        widget.workoutExerciseId,
        sets,
        _repsController.text.isNotEmpty ? _repsController.text : null,
        restSeconds,
        orderIndex,
        context,
      );

      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 100));

        if (mounted) {
          Navigator.pop(context);
        }
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
      appBar: AppBar(title: const Text('Modifier l\'exercice'), elevation: 0),
      body: SafeArea(
        child: _isLoadingData
            ? const Center(child: CircularProgressIndicator())
            : Consumer<WorkoutExerciseStore>(
                builder: (context, store, _) {
                  final workoutExercise = store.workoutExcercise;

                  if (workoutExercise == null) {
                    return Center(
                      child: Text(
                        'Exercice non trouvé',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Modifier l\'Exercice',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 24),

                        Text(
                          'Exercice',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[700]!),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black,
                          ),
                          child: Text(
                            exerciseName,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),

                        const SizedBox(height: 24),

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
                                    ),
                                  )
                                : const Icon(Icons.check),
                            label: Text(
                              _isSubmitting
                                  ? 'Modification en cours...'
                                  : 'Modifier l\'exercice',
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
                  );
                },
              ),
      ),
    );
  }
}
