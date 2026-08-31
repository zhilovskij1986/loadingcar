import 'package:flutter/material.dart';

import '../document_selection_form/document_list.dart';
import '../document_selection_form/model_document_list.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFFFDE7),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Рядок пошуку
          _buildSearchRow(context),
          const SizedBox(height: 16),
          //блок по клієнту
          Row(
            children: [
              _buildCounterCard('Відскан. по клієнту:', '1'),
              const SizedBox(width: 12),
              _buildCounterCard('Всього по клієнту:', '2'),
            ],
          ),
          const SizedBox(height: 16),
          // 3. Блок "Загальний"
          Row(
            children: [
              _buildCounterCard('Всього відскановано:', '1'),
              const SizedBox(width: 12),
              _buildCounterCard('Всього по реєстру:', '6'),
            ],
          ),
          const SizedBox(height: 20),
          //4.Статус
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade600),
              ),
              child: const Text(
                'Закритий',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 5. Інформаційний рядок
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Colors.grey.shade700,
              ),
              const SizedBox(width: 6),
              Text(
                '-0-(Город2+) 856263, №19-В',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextField(
              readOnly: true,
              controller: TextEditingController(text: '№00091601 ()'),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Кнопка пошуку
        SizedBox(
          width: 40,
          height: 40,
          child: IconButton.filledTonal(
            onPressed: () async {
              // Відкриваємо вікно на весь екран
              final selectedDoc = await showDialog<DocumentItem>(
                context: context,
                builder: (dialogContext) => const DocumentSelectionDialog(),
              );

              if (selectedDoc != null) {
                print('Обрано документ: ${selectedDoc.number}');
              }
            },
            icon: const Icon(Icons.search, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: Colors.teal.shade100,
              foregroundColor: Colors.teal.shade900,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ),

        const SizedBox(width: 6),
        // Кнопка оновлення
        SizedBox(
          width: 40,
          height: 40,
          child: IconButton.filledTonal(
            onPressed: () {},
            icon: Icon(Icons.sync, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: Colors.blue.shade100,
              foregroundColor: Colors.blue.shade900,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCounterCard(String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            height: 50,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.bottomRight,
            child: Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
