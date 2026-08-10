import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/api/api_client.dart';
import '../../core/api/request_repository.dart';
import '../../core/app_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthRepository _apiService = AuthRepository(ApiClient());

  String _pin = '';
  bool _isLoading = false;

  final List<String> _buttons = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'C',
    '0',
    'OK',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Авторизація',
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Введіть код',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                floatingLabelStyle: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: const BorderSide(width: 4.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    width: 2.5,
                    color: Colors.grey.shade400,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    width: 3.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                contentPadding: const EdgeInsetsGeometry.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
              ),
              child: SizedBox(
                height: 35,
                child: Center(
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : Text(
                          _pin.isEmpty ? '' : '*' * _pin.length,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 8,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _buttons.length,
              itemBuilder: (context, index) {
                final text = _buttons[index];

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300, width: 3),
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  // Якщо йде завантаження — кнопки неактивні (null)
                  onPressed: _isLoading ? null : () => _onKeyTap(text),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: text == 'C'
                          ? Colors.redAccent
                          : text == 'OK'
                          ? Colors.green
                          : null,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _onKeyTap(String value) {
    setState(() {
      if (value == 'OK') {
        if (_pin.length == 4) {
          _verifyPin(_pin);
        }
      } else if (value == 'C') {
        _pin = '';
      } else {
        if (_pin.length < 4) {
          _pin += value;
        }
      }
    });
  }

  Future<void> _verifyPin(String pin) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final numTcd = await AppPreferences.getNumTcd();

      final response = await _apiService.checkEmployee(pin, numTcd: numTcd);

      if (!mounted) return;

      // Отримуємо значення з ключа Message
      final String message = response['Message'] ?? '';

      if (message.isNotEmpty) {
        context.go('/main', extra: message);
      } else {
        _showErrorSnackBar('Користувача з таким PIN не знайдено');
      }
    } catch (e) {
      _showErrorSnackBar(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _pin = '';
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
