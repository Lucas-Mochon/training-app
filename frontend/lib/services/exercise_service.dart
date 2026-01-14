import 'package:frontend/services/base_service.dart';
import 'package:frontend/store/auth_store.dart';

class ExerciseService extends BaseService {
  ExerciseService({required AuthStore authStore})
    : super(
        baseUrl: 'http://localhost:3000/api/exercices',
        authStore: authStore,
      );

  Future<Map<String, dynamic>> list() async {
    return await get('/');
  }

  Future<Map<String, dynamic>> getOne(int id) async {
    return await get('/$id');
  }
}
