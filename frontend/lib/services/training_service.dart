import 'package:frontend/services/base_service.dart';
import 'package:frontend/store/auth_store.dart';

class TrainingService extends BaseService {
  TrainingService({required AuthStore authStore})
    : super(
        baseUrl: 'http://localhost:3000/api/training-sessions',
        authStore: authStore,
      );

  Future<Map<String, dynamic>> list() async {
    return await get('/');
  }

  Future<Map<String, dynamic>> getOne(int id) async {
    return await get('/$id');
  }

  Future<Map<String, dynamic>> create(
    int duration,
    int feeling,
    String workoutId,
    String userId,
  ) async {
    return await post('/create', {
      'duration': duration,
      'feeling': feeling,
      'workoutId': workoutId,
      'userId': userId,
    });
  }
}
