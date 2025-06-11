import 'package:intl/intl.dart';

enum BookingStatus { pending, confirmed, rejected, completed, cancelled }

class Booking {
  final String id;
  final String salonId;
  final String clientId;
  final String ownerId;
  final DateTime eventDate;
  final String eventTime;
  final String eventType;
  final int guestCount;
  final List<String> additionalServices;
  final double totalAmount;
  final BookingStatus status;
  final DateTime createdAt;
  final String? notes;

  Booking({
    required this.id,
    required this.salonId,
    required this.clientId,
    required this.ownerId,
    required this.eventDate,
    required this.eventTime,
    required this.eventType,
    required this.guestCount,
    required this.additionalServices,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.notes,
  });

  String get formattedDate => DateFormat('dd/MM/yyyy').format(eventDate);
  String get formattedCreatedAt => DateFormat('dd/MM/yyyy HH:mm').format(createdAt);

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      salonId: json['salonId'],
      clientId: json['clientId'],
      ownerId: json['ownerId'],
      eventDate: DateTime.parse(json['eventDate']),
      eventTime: json['eventTime'],
      eventType: json['eventType'],
      guestCount: json['guestCount'],
      additionalServices: List<String>.from(json['additionalServices']),
      totalAmount: json['totalAmount'].toDouble(),
      status: BookingStatus.values.firstWhere(
            (e) => e.toString().split('.').last == json['status'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'salonId': salonId,
      'clientId': clientId,
      'ownerId': ownerId,
      'eventDate': eventDate.toIso8601String(),
      'eventTime': eventTime,
      'eventType': eventType,
      'guestCount': guestCount,
      'additionalServices': additionalServices,
      'totalAmount': totalAmount,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'notes': notes,
    };
  }
}
