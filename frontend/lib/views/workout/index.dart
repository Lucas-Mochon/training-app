import 'package:flutter/material.dart';
import 'package:frontend/store/auth_store.dart';
import 'package:frontend/store/page/user/profil_store.dart';
import 'package:frontend/store/page/workout/workout_store.dart';
import 'package:frontend/views/workout/detail.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileStore = context.read<ProfileStore>();
      final userId = profileStore.user?['id'] as String?;

      if (userId != null) {
        context.read<WorkoutStore>().getList(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WorkoutStore(authStore: context.read<AuthStore>()),
      child: Consumer2<ProfileStore, WorkoutStore>(
        builder: (context, profileStore, workoutStore, _) {
          final userId = profileStore.user?['id'] as String?;

          if (workoutStore.workouts == null &&
              !workoutStore.isLoading &&
              workoutStore.error == null &&
              userId != null) {
            workoutStore.getList(userId);
          }

          if (workoutStore.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (workoutStore.error != null) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Erreur : ${workoutStore.error}',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          userId != null ? workoutStore.getList(userId) : null,
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          final workouts = workoutStore.workouts ?? [];

          if (workouts.isEmpty) {
            return const Scaffold(
              body: Center(
                child: Text(
                  'Aucun entraînement disponible',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Mes Entraînements'),
              elevation: 0,
            ),
            body: SafeArea(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: workouts.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final workout = workouts[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              WorkoutDetailPage(workoutId: workout.id),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        workout.goal.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${workout.duration} min',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Créé le ${_formatDate(workout.createdAt)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
