import 'package:flutter/material.dart';
import 'package:frontend/store/auth_store.dart';
import 'package:frontend/store/page/exercise/index_store.dart';
import 'package:provider/provider.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExerciseStore(authStore: context.read<AuthStore>()),
      child: Consumer<ExerciseStore>(
        builder: (context, store, _) {
          if (store.isLoading || store.exercises == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (store.error != null) {
            return const Scaffold(
              body: Center(
                child: Text(
                  'Erreur lors du chargement des exercices',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          }

          final exercises = store.exercises!;

          if (exercises.isEmpty) {
            return const Scaffold(
              body: Center(
                child: Text(
                  'Aucun exercice disponible',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          }

          return Scaffold(
            body: SafeArea(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: exercises.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final exercise = exercises[index];

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercise['name'] ?? 'Exercice',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          if (exercise['description'] != null)
                            Text(
                              exercise['description'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                        ],
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
}
