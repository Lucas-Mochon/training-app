import 'package:flutter/material.dart';
import 'package:frontend/constants/dto/workout_detail.dart';
import 'package:frontend/store/page/workout/workout_store.dart';
import 'package:frontend/views/workout/update.dart';
import 'package:frontend/views/workout_exercise/create.dart';
import 'package:provider/provider.dart';

class WorkoutDetailPage extends StatefulWidget {
  final String workoutId;

  const WorkoutDetailPage({super.key, required this.workoutId});

  @override
  State<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkoutStore>().getOne(widget.workoutId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutStore>(
      builder: (context, store, _) {
        if (store.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (store.error != null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Erreur : ${store.error}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Retour'),
                  ),
                ],
              ),
            ),
          );
        }

        if (store.workoutDetail == null) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Aucun entraînement disponible',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        }

        final detail = store.workoutDetail!;
        final workout = detail.workout;

        return Scaffold(
          appBar: AppBar(title: Text(workout.goal.name), elevation: 0),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.goal.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          'Durée',
                          '${workout.duration} minutes',
                          Icons.timer,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow('Objectif', workout.goal.name, Icons.tab),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Titre Exercices
                  Text(
                    'Exercices (${detail.exercises.length})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  if (detail.exercises.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Aucun exercice ajouté',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  else
                    Column(
                      children: detail.exercises.map((item) {
                        return _buildExerciseCard(item);
                      }).toList(),
                    ),

                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorkoutExerciseCreatePage(
                                workoutId: widget.workoutId,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Ajouter un exercice'),
                      ),
                      const SizedBox(width: 12),
                      FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WorkoutUpdatePage(workout: workout),
                            ),
                          );
                        },
                        child: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.blue),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExerciseCard(WorkoutDetailExerciseItem item) {
    final exercise = item.exercise;
    final workoutExercise = item.workoutExercise;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exercise.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              if (exercise.difficulty != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    exercise.difficulty!.value,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (exercise.equipment != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    exercise.equipment!.value,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[700],
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildExerciseDetail(
                'Séries',
                workoutExercise.sets?.toString() ?? '-',
                Icons.repeat,
              ),
              _buildExerciseDetail(
                'Reps',
                workoutExercise.reps?.toString() ?? '-',
                Icons.fitness_center,
              ),
              _buildExerciseDetail(
                'Repos',
                workoutExercise.restSeconds != null
                    ? '${workoutExercise.restSeconds}s'
                    : '-',
                Icons.timer,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
