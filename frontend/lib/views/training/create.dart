import 'package:flutter/material.dart';
import 'package:frontend/store/page/training/training_store.dart';
import 'package:frontend/store/page/user/profil_store.dart';
import 'package:frontend/store/page/workout/workout_store.dart';
import 'package:provider/provider.dart';

class TrainingCreatePage extends StatefulWidget {
  const TrainingCreatePage({super.key});

  @override
  State<TrainingCreatePage> createState() => _TrainingCreatePageState();
}

class _TrainingCreatePageState extends State<TrainingCreatePage> {
  final _durationController = TextEditingController();

  String? _selectedWorkoutId;
  int _feeling = 5;

  bool _isSubmitting = false;
  bool _isLoadingWorkouts = false;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _loadWorkouts() async {
    setState(() => _isLoadingWorkouts = true);
    try {
      final profileStore = context.read<ProfileStore>();
      final userId = profileStore.user?['id'] as String?;

      if (userId != null) {
        await context.read<WorkoutStore>().getList(userId, null, null, null);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur chargement workouts : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingWorkouts = false);
    }
  }

  Future<void> _handleSubmit() async {
    final duration = int.tryParse(_durationController.text);

    if (duration == null || duration <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Durée invalide')));
      return;
    }

    if (_selectedWorkoutId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sélectionne un workout')));
      return;
    }

    final profileStore = context.read<ProfileStore>();
    final userId = profileStore.user?['id'] as String?;

    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Utilisateur non connecté')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await context.read<Trainingstore>().create(
        duration,
        _feeling,
        _selectedWorkoutId!,
        userId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Entraînement créé 💪'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvel entraînement'), elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Créer une session',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),

              Text('Workout', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              _isLoadingWorkouts
                  ? const Center(child: CircularProgressIndicator())
                  : Consumer<WorkoutStore>(
                      builder: (context, store, _) {
                        if (store.workouts == null || store.workouts!.isEmpty) {
                          return _emptyBox('Aucun workout disponible');
                        }

                        return _dropdownBox(
                          DropdownButton<String>(
                            value: _selectedWorkoutId,
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: const Text('Sélectionner un workout'),
                            items: store.workouts!.map((workout) {
                              return DropdownMenuItem(
                                value: workout.id,
                                child: Text(workout.goal.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() => _selectedWorkoutId = value);
                            },
                          ),
                        );
                      },
                    ),

              const SizedBox(height: 24),

              Text(
                'Durée (minutes)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Ex: 60',
                  prefixIcon: const Icon(Icons.timer),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Ressenti : $_feeling / 5',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Slider(
                value: _feeling.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: _feeling.toString(),
                onChanged: (value) {
                  setState(() => _feeling = value.toInt());
                },
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: Text(
                    _isSubmitting ? 'Création...' : 'Créer l\'entraînement',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdownBox(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[700]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }

  Widget _emptyBox(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[700]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(color: Colors.grey)),
    );
  }
}
