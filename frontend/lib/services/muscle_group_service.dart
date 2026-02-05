import 'package:frontend/services/base_service.dart';
import 'package:frontend/store/auth_store.dart';

class MuscleGroupService extends BaseService {
  MuscleGroupService({required AuthStore authStore})
    : super(
        baseUrl: 'http://localhost:3000/api/muscle-groups',
        authStore: authStore,
      );

  Future<Map<String, dynamic>> list() async {
    return await get('/');
  }
}
