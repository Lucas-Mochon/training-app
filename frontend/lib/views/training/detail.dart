import 'package:flutter/material.dart';
import 'package:frontend/models/trainingSession_model.dart';
import 'package:frontend/store/page/workout/workout_store.dart';
import 'package:frontend/views/workout/detail.dart';
import 'package:provider/provider.dart';

class TrainingDetailPage extends StatefulWidget {
  final TrainingSession training;

  const TrainingDetailPage({super.key, required this.training});

  @override
  State<TrainingDetailPage> createState() => _TrainingDetailPageState();
}

class _TrainingDetailPageState extends State<TrainingDetailPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkoutStore>().getOne(widget.training.workoutId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détail entraînement'), elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoCard(
                context,
                title: 'Session',
                children: [
                  _infoRow(
                    Icons.timer,
                    'Durée',
                    '${widget.training.duration} min',
                  ),
                  _infoRow(
                    Icons.fitness_center,
                    'Ressenti',
                    '${widget.training.feeling}/10',
                  ),
                  _infoRow(
                    Icons.calendar_today,
                    'Date',
                    _formatDate(widget.training.performedAt),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Consumer<WorkoutStore>(
                builder: (context, store, _) {
                  if (store.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (store.error != null || store.workout == null) {
                    return _infoCard(
                      context,
                      title: 'Workout',
                      children: const [
                        Text('Impossible de charger le workout'),
                      ],
                    );
                  }

                  final workout = store.workout!;

                  return _infoCard(
                    context,
                    title: 'Workout',
                    children: [
                      _infoRow(Icons.flag, 'Objectif', workout.goal.name),
                      _infoRow(
                        Icons.timer,
                        'Durée prévue',
                        '${workout.duration} min',
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Voir le workout'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    WorkoutDetailPage(workoutId: workout.id),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
