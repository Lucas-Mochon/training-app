import 'package:flutter/material.dart';
import 'package:frontend/store/auth_store.dart';
import 'package:frontend/store/page/exercise/exercise_store.dart';
import 'package:frontend/views/exercise/detail.dart';
import 'package:provider/provider.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExerciseStore>().getList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExerciseStore(authStore: context.read<AuthStore>()),
      child: Consumer<ExerciseStore>(
        builder: (context, store, _) {
          if (store.exercises == null &&
              !store.isLoading &&
              store.error == null) {
            store.getList();
          }

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
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Erreur : ${store.error}',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => store.getList(),
                      child: const Text('Réessayer'),
                    ),
                  ],
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
            appBar: AppBar(title: const Text('Exercices'), elevation: 0),
            body: SafeArea(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: exercises.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final exercise = exercises[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ExerciseDetailPage(exerciseId: exercise.id),
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
                                  child: Text(
                                    exercise.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (exercise.description != null)
                              Text(
                                exercise.description!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
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
}
