class Salon {
  final String id;
  final String name;
  final String location;      // Esto puede ser la dirección o ciudad
  final String address;       // Dirección completa o detallada
  final String description;   // Texto descriptivo del salón
  final double price;
  final int capacity;
  final List<String> images;
  final String ownerId;
  final List<String> services;
  final double rating;        // Valor numérico para rating (ej. 4.5)
  final int reviewCount;      // Número de opiniones/reviews
  final Map<String, bool> amenities;

  Salon({
    required this.id,
    required this.name,
    required this.location,
    required this.address,
    required this.description,
    required this.price,
    required this.capacity,
    required this.images,
    required this.ownerId,
    required this.services,
    required this.rating,
    required this.reviewCount,
    required this.amenities,
  });
}
