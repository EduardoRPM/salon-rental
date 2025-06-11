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
      address: 'Av. de las Estrellas 123, Ciudad de México',
      description: 'Espacioso salón para eventos sociales en Ciudad de México.',
      price: 30000,
      capacity: 150,
      images: ['https://example.com/salon1.jpg'],
      ownerId: 'owner1',                  // <- agregar ownerId
      services: ['Banquete', 'Decoración', 'Música'],  // <- agregar servicios
      rating: 4.5,
      reviewCount: 10,
      amenities: {
        'wifi': true,
        'parking': true,
        'airConditioning': true,
      },
    ),
    Salon(
      id: 'salon2',
      name: 'Salón Los Jardines',
      location: 'Guadalajara',
      address: 'Calle de los Jardines 456, Guadalajara',
      description: 'Hermoso jardín para bodas y eventos especiales.',
      price: 20000,
      capacity: 100,
      images: ['https://example.com/salon2.jpg'],
      ownerId: 'owner2',
      services: ['Banquete', 'Iluminación'],
      rating: 4.2,
      reviewCount: 8,
      amenities: {
        'wifi': true,
        'parking': false,
        'airConditioning': true,
      },
    ),
    Salon(
      id: 'salon3',
      name: 'Salón Eleganza',
      location: 'Monterrey',
      address: 'Av. Elegancia 789, Monterrey',
      description: 'Salón elegante y moderno para grandes celebraciones.',
      price: 40000,
      capacity: 200,
      images: ['https://example.com/salon3.jpg'],
      ownerId: 'owner3',
      services: ['Banquete', 'DJ', 'Coctelería'],
      rating: 4.8,
      reviewCount: 15,
      amenities: {
        'wifi': true,
        'parking': true,
        'airConditioning': true,
        'pool': false,
      },
    ),
  ];

}
