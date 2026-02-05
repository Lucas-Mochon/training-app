import 'package:flutter/material.dart';
import 'package:frontend/constants/enum/workout_goal_enum.dart';
import 'package:frontend/store/page/user/profil_store.dart';
import 'package:frontend/store/page/workout/workout_store.dart';
import 'package:frontend/views/generate-workout/index.dart';
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
    if (userId == null) return;

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

  void _resetFilters() {
    setState(() {
      _minDurationController.clear();
      _maxDurationController.clear();
      _selectedGoal = null;
    });
    _applyFilters();
  }

  Future<void> _navigateToGenerate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GenerateWorkoutPage()),
    );

    if (result == true && mounted) {
      _applyFilters();
    }
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WorkoutCreatePage()),
        );
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _buildGenerateButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _navigateToGenerate,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.auto_awesome, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'Générer un entraînement',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProfileStore, WorkoutStore>(
      builder: (context, profileStore, workoutStore, _) {
        final workouts = workoutStore.workouts ?? [];

        return Scaffold(
          appBar: AppBar(title: const Text('Mes Entraînements'), elevation: 0),
          floatingActionButton: _buildFloatingActionButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGenerateButton(),
                    const SizedBox(height: 24),
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
                              prefixIcon: const Icon(Icons.timer),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
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
                              prefixIcon: const Icon(Icons.timer),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
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
                          ...Workoutgoal.values.map(
                            (goal) => DropdownMenuItem(
                              value: goal,
                              child: Text(goal.name),
                            ),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => _selectedGoal = value),
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
                child: Builder(
                  builder: (_) {
                    if (workoutStore.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (workoutStore.error != null) {
                      return Center(
                        child: Text(
                          'Erreur : ${workoutStore.error}',
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    if (workouts.isEmpty) {
                      return const Center(
                        child: Text(
                          'Aucun entraînement disponible',
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: workouts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final workout = workouts[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
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
                                    style: TextStyle(color: Colors.grey[600]),
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
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
