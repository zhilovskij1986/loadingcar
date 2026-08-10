import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String _host = '192.168.3.144';
  static const int _port = 80;
  static const String _publication = 'begliy_test';
  static const String _serviceName = 'apiv2';

  final String _baseUrl = 'http://$_host:$_port/$_publication/hs/$_serviceName';

  static const String _login = 'tradev2';
  static const String _password = 'Fnjdew-nqnyIDNB+df812NNjao';

  Map<String, String> get _headers {
    final String credentials = '$_login:$_password';
    final String encodedCredentials = base64Encode(utf8.encode(credentials));

    return {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Basic $encodedCredentials',
    };
  }

  // Універсальний метод для виконання POST-запитів
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await http
          .post(url, headers: _headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);

        if (decodedBody.isEmpty) {
          throw Exception('Сервер повернув порожню відповідь');
        }

        return jsonDecode(decodedBody) as Map<String, dynamic>;
      } else {
        throw Exception('Сервер повернув код: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Сервер не відповідає. Перевірте зєднання');
    } catch (e) {
      throw Exception('Помилка зєднання: $e');
    }
  }
}
