import 'api_client.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  // Перевірка працівника
  Future<Map<String, dynamic>> checkEmployee(
    String pin, {
    required String numTcd,
  }) async {
    return await _apiClient.post('/employee', {
      'num_tcd': numTcd,
      'barcode': pin,
    });
  }
}
