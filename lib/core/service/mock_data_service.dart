import '../models/user.dart';
import '../models/booking.dart';
import '../models/salon.dart';

class MockDataService {
  static List<User> mockUsers = [/* ... */]; // Ya lo tienes
  static List<Booking> mockBookings = [/* ... */]; // Ya lo tienes

  static List<Salon> mockSalons = [
    Salon(
      id: 'salon1',
      name: 'Salón Las Estrellas',
      location: 'Ciudad de México',
      price: 30000,
      capacity: 150,
      images: ['https://example.com/salon1.jpg'],
      ownerId: 'owner1',                  // <- agregar ownerId
      services: ['Banquete', 'Decoración', 'Música'],  // <- agregar servicios
    ),
    Salon(
      id: 'salon2',
      name: 'Salón Los Jardines',
      location: 'Guadalajara',
      price: 20000,
      capacity: 100,
      images: ['https://example.com/salon2.jpg'],
      ownerId: 'owner2',
      services: ['Banquete', 'Iluminación'],
    ),
    Salon(
      id: 'salon3',
      name: 'Salón Eleganza',
      location: 'Monterrey',
      price: 40000,
      capacity: 200,
      images: ['https://example.com/salon3.jpg'],
      ownerId: 'owner3',
      services: ['Banquete', 'DJ', 'Coctelería'],
    ),
  ];

}
