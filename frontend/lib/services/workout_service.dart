import 'package:frontend/constants/enum/workoutGoal_enum.dart';
import 'package:frontend/services/base_service.dart';
import 'package:frontend/store/auth_store.dart';

class WorkoutService extends BaseService {
  WorkoutService({required AuthStore authStore})
    : super(
        baseUrl: 'http://localhost:3000/api/workouts',
        authStore: authStore,
      );

  Future<Map<String, dynamic>> list(
    String userId,
    int? minDuration,
    int? maxDuration,
    Workoutgoal? goal,
  ) async {
    final Map<String, dynamic> queryParams = {'userId': userId};

    if (minDuration != null) {
      queryParams['minDuration'] = minDuration.toString();
    }

    if (maxDuration != null) {
      queryParams['maxDuration'] = maxDuration.toString();
    }

    if (goal?.name != null) {
      queryParams['goal'] = goal!.name;
    }

    final uri = Uri(path: '/', queryParameters: queryParams).toString();
    return await get(uri);
  }

  Future<Map<String, dynamic>> getOne(String id) async {
    return await get('/$id');
  }

  Future<Map<String, dynamic>> create(
    String userId,
    int duration,
    Workoutgoal goal,
  ) async {
    return await post('/create', {
      'userId': userId,
      'duration': duration,
      'goal': goal.value,
    });
  }

  Future<Map<String, dynamic>> update(
    String id,
    int duration,
    Workoutgoal goal,
  ) async {
    return await put('/update', {
      'id': id,
      'duration': duration,
      'goal': goal.value,
    });
  }
}
