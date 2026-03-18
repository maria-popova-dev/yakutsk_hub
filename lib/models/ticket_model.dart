import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  final String id;
  final String destination;
  final double price;
  final DateTime date;
  final bool isSubsidized;
  final bool isInternational;

  Ticket({
    required this.id,
    required this.destination,
    required this.price,
    required this.date,
    this.isSubsidized = false,
    this.isInternational = false,
  });
  factory Ticket.fromMap(Map<String, dynamic> map, String documentId) {
    final dynamic rawDate = map['date'];
    DateTime dateValue;
    if (rawDate is Timestamp) {
      dateValue = rawDate.toDate();
    } else {
      dateValue = DateTime.now();
    }

    return Ticket(
      id: documentId,
      destination: map['destination'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      date: dateValue,
      isSubsidized: map['isSubsidized'] ?? false,
      isInternational: map['isInternational'] ?? false,
    );
  }
}
