import 'package:flutter/material.dart';
import 'package:frontend/models/trainingSession_model.dart';
import 'package:frontend/store/auth_store.dart';
import 'package:frontend/store/page/training/training_store.dart';
import 'package:frontend/views/training/create.dart';
import 'package:frontend/views/training/detail.dart';
import 'package:provider/provider.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  late final TextEditingController _minController;
  late final TextEditingController _maxController;

  @override
  void initState() {
    super.initState();
    _minController = TextEditingController();
    _maxController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Trainingstore>().getList();
    });
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  List<TrainingSession> _applyFilters(List<TrainingSession> trainings) {
    final min = int.tryParse(_minController.text);
    final max = int.tryParse(_maxController.text);

    return trainings.where((t) {
      if (min != null && t.duration < min) return false;
      if (max != null && t.duration > max) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Trainingstore>(
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
                  Text('Erreur : ${store.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: store.getList,
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          );
        }

        final trainings = store.trainings ?? [];
        final filtered = _applyFilters(trainings);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Mes entraînements réalisés'),
            elevation: 0,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (context) =>
                        Trainingstore(authStore: context.read<AuthStore>()),
                    child: const TrainingCreatePage(),
                  ),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filtres',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _minController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Durée min (min)',
                                prefixIcon: Icon(Icons.timer),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _maxController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Durée max (min)',
                                prefixIcon: Icon(Icons.timer_off),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: filtered.isEmpty
                      ? const Center(child: Text('Aucun entraînement trouvé'))
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final training = filtered[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        TrainingDetailPage(training: training),
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${training.duration} min',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Ressenti : ${training.feeling}/5',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _formatDate(training.performedAt),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
