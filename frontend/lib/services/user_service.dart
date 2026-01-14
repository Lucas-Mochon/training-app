import 'package:frontend/services/base_service.dart';
import 'package:frontend/store/auth_store.dart';

class UserService extends BaseService {
  UserService({required AuthStore authStore})
    : super(baseUrl: 'http://localhost:3000/api/users', authStore: authStore);

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    return await post('/register', data);
  }

  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    return await post('/login', data);
  }

  Future<Map<String, dynamic>> refresh(Map<String, dynamic> data) async {
    return await post('/refresh', data);
  }

  Future<Map<String, dynamic>> getMe() async {
    return await get('/me');
  }

  Future<Map<String, dynamic>> edit(Map<String, dynamic> data) async {
    return await put('/edit', data);
  }

  Future<Map<String, dynamic>> deleteUser(int id) async {
    return await delete('/users/$id');
  }
}
