import 'package:frontend/services/base_service.dart';

class UserService extends BaseService {
  UserService({required String token})
    : super(baseUrl: 'http://localhost:3000/api/users', token: token);

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
