import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../service/mock_data_service.dart';

class BookingProvider with ChangeNotifier {
  List<Booking> _bookings = [];
  bool _isLoading = false;

  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;

  Future<void> loadBookings(String userId, {bool isOwner = false}) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      _bookings = MockDataService.mockBookings.where((booking) {
        return isOwner ? booking.ownerId == userId : booking.clientId == userId;
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error al cargar reservas: ${e.toString()}');
    }
  }

  Future<bool> createBooking(Booking booking) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      _bookings.add(booking);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error al crear reserva: ${e.toString()}');
      return false;
    }
  }

  Future<bool> updateBookingStatus(String bookingId, BookingStatus status) async {
    try {
      final bookingIndex = _bookings.indexWhere((b) => b.id == bookingId);
      if (bookingIndex != -1) {
        final booking = _bookings[bookingIndex];
        _bookings[bookingIndex] = Booking(
          id: booking.id,
          salonId: booking.salonId,
          clientId: booking.clientId,
          ownerId: booking.ownerId,
          eventDate: booking.eventDate,
          eventTime: booking.eventTime,
          eventType: booking.eventType,
          guestCount: booking.guestCount,
          additionalServices: booking.additionalServices,
          totalAmount: booking.totalAmount,
          status: status,
          createdAt: booking.createdAt,
          notes: booking.notes,
        );
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error al actualizar estado de reserva: ${e.toString()}');
      return false;
    }
  }

  List<Booking> getPendingBookings(String ownerId) {
    return _bookings.where((booking) =>
    booking.ownerId == ownerId && booking.status == BookingStatus.pending
    ).toList();
  }
}
