import 'package:flutter/material.dart';
import 'package:frontend/constants/enum/exercise_difficulty_enum.dart';
import 'package:frontend/constants/enum/exercise_equipment_enum.dart';
import 'package:frontend/store/page/exercise/exercise_store.dart';
import 'package:frontend/views/exercise/detail.dart';
import 'package:frontend/views/exercise/create.dart';
import 'package:provider/provider.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  late final TextEditingController _searchController;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExerciseStore>().getList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _navigateToCreate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ExerciseCreatePage()),
    );

    if (result == true && mounted) {
      await context.read<ExerciseStore>().getList();
    }
  }

  Future<void> _navigateToDetail(int exerciseId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseDetailPage(exerciseId: exerciseId),
      ),
    );

    if (result == true && mounted) {
      await context.read<ExerciseStore>().getList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseStore>(
      builder: (context, store, _) {
        if (store.exercises == null &&
            !store.isLoading &&
            store.error == null) {
          store.getList();
        }

        if (store.isLoading && store.exercises == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (store.error != null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Exercices'), elevation: 0),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
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

        final exercises = store.filteredExercises ?? [];
        final hasActiveFilters =
            store.searchQuery.isNotEmpty ||
            store.selectedDifficulty != null ||
            store.selectedEquipment != null ||
            store.isCompoundFilter != null;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Exercices'),
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _navigateToCreate,
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) => store.setSearchQuery(value),
                              decoration: InputDecoration(
                                hintText: 'Rechercher un exercice...',
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          _searchController.clear();
                                          store.setSearchQuery('');
                                        },
                                      )
                                    : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[700]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: Icon(
                                _showFilters
                                    ? Icons.filter_alt
                                    : Icons.filter_alt_outlined,
                                color: hasActiveFilters
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() => _showFilters = !_showFilters);
                              },
                            ),
                          ),
                        ],
                      ),
                      if (_showFilters) ...[
                        const SizedBox(height: 16),
                        _FilterSection(store: store),
                      ],
                    ],
                  ),
                ),

                Expanded(
                  child: exercises.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.fitness_center,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                hasActiveFilters
                                    ? 'Aucun exercice ne correspond aux filtres'
                                    : 'Aucun exercice disponible',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              if (hasActiveFilters) ...[
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => store.clearFilters(),
                                  child: const Text(
                                    'Réinitialiser les filtres',
                                  ),
                                ),
                              ],
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () => store.getList(),
                          child: ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: exercises.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final exercise = exercises[index];

                              return GestureDetector(
                                onTap: () => _navigateToDetail(exercise.id),
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                        const SizedBox(height: 12),
                                        if (exercise.description != null &&
                                            exercise.description!.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            child: Text(
                                              exercise.description!,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                        Row(
                                          children: [
                                            if (exercise.difficulty != null)
                                              _DifficultyTag(
                                                difficulty:
                                                    exercise.difficulty!,
                                              ),
                                            const SizedBox(width: 8),
                                            if (exercise.equipment != null)
                                              _EquipmentTag(
                                                equipment: exercise.equipment!,
                                              ),
                                            const SizedBox(width: 8),
                                            if (exercise.isCompound)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.purple
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const Text(
                                                  'Composé',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.purple,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FilterSection extends StatelessWidget {
  final ExerciseStore store;

  const _FilterSection({required this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[700]!),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[900],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Difficulté', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _FilterChip(
                label: 'Tous',
                selected: store.selectedDifficulty == null,
                onSelected: () => store.setDifficultyFilter(null),
              ),
              ...Exercisedifficulty.values.map(
                (difficulty) => _FilterChip(
                  label: _getDifficultyLabel(difficulty),
                  selected: store.selectedDifficulty == difficulty,
                  onSelected: () => store.setDifficultyFilter(difficulty),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text('Équipement', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _FilterChip(
                label: 'Tous',
                selected: store.selectedEquipment == null,
                onSelected: () => store.setEquipmentFilter(null),
              ),
              ...ExerciseEquipment.values.map(
                (equipment) => _FilterChip(
                  label: _getEquipmentLabel(equipment),
                  selected: store.selectedEquipment == equipment,
                  onSelected: () => store.setEquipmentFilter(equipment),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            'Type d\'exercice',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _FilterChip(
                label: 'Tous',
                selected: store.isCompoundFilter == null,
                onSelected: () => store.setCompoundFilter(null),
              ),
              _FilterChip(
                label: 'Isolation',
                selected: store.isCompoundFilter == false,
                onSelected: () => store.setCompoundFilter(false),
              ),
              _FilterChip(
                label: 'Composé',
                selected: store.isCompoundFilter == true,
                onSelected: () => store.setCompoundFilter(true),
              ),
            ],
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => store.clearFilters(),
              icon: const Icon(Icons.clear),
              label: const Text('Réinitialiser les filtres'),
            ),
          ),
        ],
      ),
    );
  }

  String _getDifficultyLabel(Exercisedifficulty difficulty) {
    switch (difficulty) {
      case Exercisedifficulty.easy:
        return 'Facile';
      case Exercisedifficulty.medium:
        return 'Moyen';
      case Exercisedifficulty.hard:
        return 'Difficile';
    }
  }

  String _getEquipmentLabel(ExerciseEquipment equipment) {
    switch (equipment) {
      case ExerciseEquipment.barbell:
        return 'Barre';
      case ExerciseEquipment.dumbbell:
        return 'Haltère';
      case ExerciseEquipment.bodyweight:
        return 'Poids du corps';
      case ExerciseEquipment.machine:
        return 'Machine';
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      backgroundColor: Colors.transparent,
      selectedColor: Colors.blue.withOpacity(0.3),
      side: BorderSide(color: selected ? Colors.blue : Colors.grey[700]!),
    );
  }
}

class _DifficultyTag extends StatelessWidget {
  final Exercisedifficulty difficulty;

  const _DifficultyTag({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (difficulty) {
      case Exercisedifficulty.easy:
        color = Colors.green;
        label = 'Facile';
        break;
      case Exercisedifficulty.medium:
        color = Colors.orange;
        label = 'Moyen';
        break;
      case Exercisedifficulty.hard:
        color = Colors.red;
        label = 'Difficile';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EquipmentTag extends StatelessWidget {
  final ExerciseEquipment equipment;

  const _EquipmentTag({required this.equipment});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (equipment) {
      case ExerciseEquipment.barbell:
        color = Colors.blue;
        label = 'Barre';
        break;
      case ExerciseEquipment.dumbbell:
        color = Colors.amber;
        label = 'Haltère';
        break;
      case ExerciseEquipment.bodyweight:
        color = Colors.teal;
        label = 'Poids du corps';
        break;
      case ExerciseEquipment.machine:
        color = Colors.indigo;
        label = 'Machine';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
