import 'package:frontend/services/base_service.dart';
import 'package:frontend/store/auth_store.dart';

class WorkoutBuilderService extends BaseService {
  WorkoutBuilderService({required AuthStore authStore})
    : super(
        baseUrl: 'http://localhost:3000/api/workout-builder',
        authStore: authStore,
      );

  Future<Map<String, dynamic>> generateWorkout(
    String userId,
    int duration,
    String description,
    String muscleGroup,
  ) async {
    return await post('/generate-workout', {
      'user_id': userId,
      'duration': duration,
      'description': description,
      'muscle_group': muscleGroup,
    });
  }
}
