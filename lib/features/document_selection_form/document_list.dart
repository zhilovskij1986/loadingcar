import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model_document_list.dart';

class DocumentSelectionDialog extends StatefulWidget {
  const DocumentSelectionDialog({super.key});

  @override
  State<DocumentSelectionDialog> createState() =>
      _DocumentSelectionDialogState();
}

class _DocumentSelectionDialogState extends State<DocumentSelectionDialog> {
  final List<String> _deliveryTypes = [
    'Доставка',
    'Точка видачі',
    'Експрес доставка',
    'Нова пошта',
  ];

  String? _selectedDeliveryType;
  bool _isLoading = false;
  List<DocumentItem> _documents = [];

  Future<void> _fetchDocumentsByDeliveryType(String type) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Замініть це на ваш реальний API запит до бази даних (http/dio)
      // Example: final response = await http.get(Uri.parse('https://api.example.com/docs?type=$type'));
      await Future.delayed(
        const Duration(milliseconds: 600),
      ); // Симуляція мережива

      // Тестові дані залежно від обраного типу
      setState(() {
        _documents = List.generate(
          4,
          (index) => DocumentItem(
            date: '28.08.2026',
            number: '№0009160${index + 1}',
            destination: '$type - Напрямок ${index + 1}',
            status: 'В обробці',
          ),
        );
      });
    } catch (e) {
      // Обробка помилки
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          automaticallyImplyLeading: false,
          title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween),
        ),
      ),
    );
  }
}
