// Модель для таблиці документів
class DocumentItem {
  final String date;
  final String number;
  final String destination;
  final String status;

  DocumentItem({
    required this.date,
    required this.number,
    required this.destination,
    required this.status,
  });
}
