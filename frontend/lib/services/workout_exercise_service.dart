import 'package:frontend/services/base_service.dart';
import 'package:frontend/store/auth_store.dart';

class WorkoutExerciseService extends BaseService {
  WorkoutExerciseService({required AuthStore authStore})
    : super(
        baseUrl: 'http://localhost:3000/api/workout-exercises',
        authStore: authStore,
      );

  Future<Map<String, dynamic>> getOne(int id) async {
    return await get('/$id');
  }

  Future<Map<String, dynamic>> create(
    String workoutId,
    int exerciseId,
    int? sets,
    String? reps,
    int? restSeconds,
    int? orderIndex,
  ) async {
    return await post('/create', {
      'workoutId': workoutId,
      'exerciseId': exerciseId,
      'sets': sets,
      'reps': reps,
      'rest_seconds': restSeconds,
      'order_index': orderIndex,
    });
  }

  Future<Map<String, dynamic>> update(
    int id,
    int? sets,
    String? reps,
    int? restSeconds,
    int? orderIndex,
  ) async {
    return await put('/update', {
      'sets': sets,
      'reps': reps,
      'rest_seconds': restSeconds,
      'order_index': orderIndex,
    });
  }

  Future<Map<String, dynamic>> deleteById(int id) async {
    return await super.delete('/$id');
  }
}
