import 'package:flutter/material.dart';
import 'package:frontend/store/auth_store.dart';
import 'package:frontend/store/page/exercise/exercise_store.dart';
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExerciseStore(authStore: context.read<AuthStore>()),
      child: Consumer<ExerciseStore>(
        builder: (context, store, _) {
          if (store.exercise == null &&
              !store.isLoading &&
              store.error == null) {
            store.getOne(widget.exerciseId);
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
            appBar: AppBar(title: Text(exercise.name), elevation: 0),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

                    if (exercise.description != null) ...[
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          exercise.description!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
