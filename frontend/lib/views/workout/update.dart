import 'package:flutter/material.dart';
import 'package:frontend/constants/enum/workout_goal_enum.dart';
import 'package:frontend/models/workout_model.dart';
import 'package:frontend/store/page/workout/workout_store.dart';
import 'package:provider/provider.dart';

class WorkoutUpdatePage extends StatefulWidget {
  final Workout workout;

  const WorkoutUpdatePage({super.key, required this.workout});

  @override
  State<WorkoutUpdatePage> createState() => _WorkoutUpdatePageState();
}

class _WorkoutUpdatePageState extends State<WorkoutUpdatePage> {
  late final TextEditingController _durationController;
  late Workoutgoal _selectedGoal;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _durationController = TextEditingController(
      text: widget.workout.duration.toString(),
    );
    _selectedGoal = widget.workout.goal;
  }

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_durationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer une durée')),
      );
      return;
    }

    final duration = int.tryParse(_durationController.text);
    if (duration == null || duration <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La durée doit être un nombre positif')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await context.read<WorkoutStore>().update(
        widget.workout.id,
        duration,
        _selectedGoal,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Entraînement modifié avec succès !'),
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
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier l\'entraînement'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Modifier Entraînement',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),

              Text('Objectif', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[700]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<Workoutgoal>(
                  value: _selectedGoal,
                  isExpanded: true,
                  underline: const SizedBox(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  items: Workoutgoal.values.map((goal) {
                    return DropdownMenuItem(
                      value: goal,
                      child: Text(goal.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedGoal = value);
                    }
                  },
                ),
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
                  hintText: 'Ex: 30',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.timer),
                  suffixText: 'min',
                ),
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
                    _isSubmitting
                        ? 'Modification...'
                        : 'Modifier l\'entraînement',
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
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Annuler'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
