import 'package:flutter/material.dart';
import 'package:frontend/constants/enum/exercise_difficulty_enum.dart';
import 'package:frontend/constants/enum/exercise_equipment_enum.dart';
import 'package:frontend/store/page/exercise/exercise_store.dart';
import 'package:frontend/views/exercise/update.dart';
import 'package:provider/provider.dart';

class ExerciseDetailPage extends StatefulWidget {
  final int exerciseId;

  const ExerciseDetailPage({super.key, required this.exerciseId});

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExerciseStore>().getOne(widget.exerciseId);
    });
  }

  Future<void> _navigateToUpdate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseUpdatePage(exerciseId: widget.exerciseId),
      ),
    );

    // 👇 Si result == true, recharge avec forceRefresh
    if (result == true && mounted) {
      await context.read<ExerciseStore>().getOne(
        widget.exerciseId,
        forceRefresh: true, // 👈 Force le rechargement depuis l'API
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseStore>(
      builder: (context, store, _) {
        if (store.exercise == null && !store.isLoading && store.error == null) {
          store.getOne(widget.exerciseId);
        }

        if (store.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (store.error != null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Erreur'), elevation: 0),
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

        if (store.exercise == null) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Aucun exercice disponible',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        }

        final exercise = store.exercise!;

        return Scaffold(
          appBar: AppBar(
            title: Text(exercise.name),
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: _navigateToUpdate,
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre
                  Text(
                    exercise.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  const SizedBox(height: 24),

                  // Badges
                  Row(
                    children: [
                      if (exercise.difficulty != null)
                        _DifficultyBadge(difficulty: exercise.difficulty!),
                      const SizedBox(width: 12),
                      if (exercise.equipment != null)
                        _EquipmentBadge(equipment: exercise.equipment!),
                      const SizedBox(width: 12),
                      if (exercise.isCompound)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.purple.withOpacity(0.5),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.fitness_center,
                                size: 16,
                                color: Colors.purple,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Composé',
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  if (exercise.description != null &&
                      exercise.description!.isNotEmpty) ...[
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[700]!),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[900],
                      ),
                      child: Text(
                        exercise.description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[300],
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  Text(
                    'Informations',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[700]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _InfoRow(label: 'ID', value: exercise.id.toString()),
                        const Divider(),
                        _InfoRow(
                          label: 'Difficulté',
                          value: _getDifficultyLabel(exercise.difficulty),
                        ),
                        const Divider(),
                        _InfoRow(
                          label: 'Équipement',
                          value: _getEquipmentLabel(exercise.equipment),
                        ),
                        const Divider(),
                        _InfoRow(
                          label: 'Type',
                          value: exercise.isCompound ? 'Composé' : 'Isolation',
                        ),
                        const Divider(),
                        _InfoRow(
                          label: 'Créé le',
                          value: exercise.createdAt != null
                              ? _formatDate(exercise.createdAt!)
                              : 'N/A',
                        ),
                        const Divider(),
                        _InfoRow(
                          label: 'Modifié le',
                          value: exercise.updatedAt != null
                              ? _formatDate(exercise.updatedAt!)
                              : 'N/A',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getDifficultyLabel(Exercisedifficulty? difficulty) {
    switch (difficulty) {
      case Exercisedifficulty.easy:
        return 'Facile';
      case Exercisedifficulty.medium:
        return 'Moyen';
      case Exercisedifficulty.hard:
        return 'Difficile';
      default:
        return 'N/A';
    }
  }

  String _getEquipmentLabel(ExerciseEquipment? equipment) {
    switch (equipment) {
      case ExerciseEquipment.barbell:
        return 'Barre';
      case ExerciseEquipment.dumbbell:
        return 'Haltère';
      case ExerciseEquipment.bodyweight:
        return 'Poids du corps';
      case ExerciseEquipment.machine:
        return 'Machine';
      default:
        return 'N/A';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _DifficultyBadge extends StatelessWidget {
  final Exercisedifficulty difficulty;

  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    IconData icon;

    switch (difficulty) {
      case Exercisedifficulty.easy:
        color = Colors.green;
        label = 'Facile';
        icon = Icons.trending_down;
        break;
      case Exercisedifficulty.medium:
        color = Colors.orange;
        label = 'Moyen';
        icon = Icons.trending_flat;
        break;
      case Exercisedifficulty.hard:
        color = Colors.red;
        label = 'Difficile';
        icon = Icons.trending_up;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EquipmentBadge extends StatelessWidget {
  final ExerciseEquipment equipment;

  const _EquipmentBadge({required this.equipment});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    IconData icon;

    switch (equipment) {
      case ExerciseEquipment.barbell:
        color = Colors.blue;
        label = 'Barre';
        icon = Icons.straighten;
        break;
      case ExerciseEquipment.dumbbell:
        color = Colors.amber;
        label = 'Haltère';
        icon = Icons.fitness_center;
        break;
      case ExerciseEquipment.bodyweight:
        color = Colors.teal;
        label = 'Poids du corps';
        icon = Icons.person;
        break;
      case ExerciseEquipment.machine:
        color = Colors.indigo;
        label = 'Machine';
        icon = Icons.settings;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 14)),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
