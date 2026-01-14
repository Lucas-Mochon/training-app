import 'package:flutter/material.dart';
import 'package:frontend/constants/enum/workoutGoal_enum.dart';
import 'package:frontend/store/page/user/profil_store.dart';
import 'package:frontend/store/page/workout/workout_store.dart';
import 'package:frontend/views/workout/create.dart';
import 'package:frontend/views/workout/detail.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  late final TextEditingController _minDurationController;
  late final TextEditingController _maxDurationController;
  Workoutgoal? _selectedGoal;

  @override
  void initState() {
    super.initState();
    _minDurationController = TextEditingController();
    _maxDurationController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileStore = context.read<ProfileStore>();
      final userId = profileStore.user?['id'] as String?;

      if (userId != null) {
        _applyFilters();
      }
    });
  }

  @override
  void dispose() {
    _minDurationController.dispose();
    _maxDurationController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final profileStore = context.read<ProfileStore>();
    final userId = profileStore.user?['id'] as String?;

    if (userId != null) {
      final minDuration = _minDurationController.text.isEmpty
          ? null
          : int.tryParse(_minDurationController.text);
      final maxDuration = _maxDurationController.text.isEmpty
          ? null
          : int.tryParse(_maxDurationController.text);

      context.read<WorkoutStore>().getList(
        userId,
        minDuration,
        maxDuration,
        _selectedGoal,
      );
    }
  }

  void _resetFilters() {
    setState(() {
      _minDurationController.clear();
      _maxDurationController.clear();
      _selectedGoal = null;
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProfileStore, WorkoutStore>(
      builder: (context, profileStore, workoutStore, _) {
        final userId = profileStore.user?['id'] as String?;

        if (workoutStore.workouts == null &&
            !workoutStore.isLoading &&
            workoutStore.error == null &&
            userId != null) {
          _applyFilters();
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
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Erreur : ${workoutStore.error}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => userId != null ? _applyFilters() : null,
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          );
        }

        final workouts = workoutStore.workouts ?? [];

        if (workouts.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Mes Entraînements'),
              elevation: 0,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Aucun entraînement disponible',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _resetFilters,
                    child: const Text('Réinitialiser les filtres'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Mes Entraînements'), elevation: 0),
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
                              controller: _minDurationController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Min (min)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: const Icon(Icons.timer),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _maxDurationController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Max (min)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: const Icon(Icons.timer),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[700]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<Workoutgoal?>(
                          value: _selectedGoal,
                          isExpanded: true,
                          underline: const SizedBox(),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          hint: const Text('Objectif'),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('Tous les objectifs'),
                            ),
                            ...Workoutgoal.values.map((goal) {
                              return DropdownMenuItem(
                                value: goal,
                                child: Text(goal.name),
                              );
                            }).toList(),
                          ],
                          onChanged: (value) {
                            setState(() => _selectedGoal = value);
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _applyFilters,
                              icon: const Icon(Icons.search),
                              label: const Text('Appliquer'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _resetFilters,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Réinitialiser'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WorkoutCreatePage(),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
