import 'package:frontend/services/base_service.dart';
import 'package:frontend/store/auth_store.dart';

class WorkoutService extends BaseService {
  WorkoutService({required AuthStore authStore})
    : super(
        baseUrl: 'http://localhost:3000/api/workouts',
        authStore: authStore,
      );

  Future<Map<String, dynamic>> list(String userId) async {
    final queryParams = {'userId': userId};
    final uri = Uri(path: '/', queryParameters: queryParams).toString();
    return await get(uri);
  }

  Future<Map<String, dynamic>> getOne(String id) async {
    return await get('/$id');
  }
}
