import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/salon_provider.dart';
import '../../../core/theme/app_theme.dart';

class SalonDetailScreen extends StatefulWidget {
  final String salonId;

  const SalonDetailScreen({super.key, required this.salonId});

  @override
  State<SalonDetailScreen> createState() => _SalonDetailScreenState();
}

class _SalonDetailScreenState extends State<SalonDetailScreen> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<SalonProvider>(
      builder: (context, salonProvider, child) {
        final salon = salonProvider.getSalonById(widget.salonId);

        if (salon == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: Text('Salón no encontrado'),
            ),
          );
        }

        final formatter = NumberFormat.currency(locale: 'es_MX', symbol: '\$');

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // App Bar con imágenes
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 300,
                          viewportFraction: 1.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                        ),
                        items: salon.images.map((image) {
                          return Image.network(
                            image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppTheme.lightGray,
                                child: const Icon(
                                  Icons.image,
                                  size: 48,
                                  color: AppTheme.mediumGray,
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      // Indicadores de imagen
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: salon.images.asMap().entries.map((entry) {
                            return Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentImageIndex == entry.key
                                    ? AppTheme.white
                                    : AppTheme.white.withOpacity(0.4),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Contenido
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título y rating
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              salon.name,
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 20,
                                color: AppTheme.primaryGold,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                salon.rating.toString(),
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                ' (${salon.reviewCount})',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Ubicación
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 20,
                            color: AppTheme.mediumGray,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              salon.address,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Capacidad y precio
                      Row(
                        children: [
                          Expanded(
                            child: _InfoCard(
                              icon: Icons.people,
                              title: 'Capacidad',
                              value: '${salon.capacity} personas',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _InfoCard(
                              icon: Icons.attach_money,
                              title: 'Precio',
                              value: formatter.format(salon.price),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Descripción
                      Text(
                        'Descripción',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        salon.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      // Servicios incluidos
                      Text(
                        'Servicios incluidos',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: salon.services.map((service) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGold.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppTheme.primaryGold.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: AppTheme.primaryGold,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  service,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.primaryGold,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      // Amenidades
                      Text(
                        'Amenidades',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 12),
                      _AmenitiesGrid(amenities: salon.amenities),
                      const SizedBox(height: 100), // Espacio para el botón flotante
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Botón flotante para reservar
          floatingActionButton: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () => context.go('/booking-request/${salon.id}'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Solicitar Reserva - ${formatter.format(salon.price)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: AppTheme.primaryGold,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmenitiesGrid extends StatelessWidget {
  final Map<String, dynamic> amenities;

  const _AmenitiesGrid({required this.amenities});

  @override
  Widget build(BuildContext context) {
    final amenityIcons = {
      'wifi': Icons.wifi,
      'parking': Icons.local_parking,
      'airConditioning': Icons.ac_unit,
      'soundSystem': Icons.speaker,
      'lighting': Icons.lightbulb,
      'kitchen': Icons.kitchen,
    };

    final amenityLabels = {
      'wifi': 'WiFi',
      'parking': 'Estacionamiento',
      'airConditioning': 'Aire Acondicionado',
      'soundSystem': 'Sistema de Sonido',
      'lighting': 'Iluminación',
      'kitchen': 'Cocina',
    };

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: amenities.length,
      itemBuilder: (context, index) {
        final entry = amenities.entries.elementAt(index);
        final isAvailable = entry.value as bool;
        final icon = amenityIcons[entry.key] ?? Icons.check;
        final label = amenityLabels[entry.key] ?? entry.key;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isAvailable
                ? AppTheme.success.withOpacity(0.1)
                : AppTheme.mediumGray.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isAvailable
                  ? AppTheme.success.withOpacity(0.3)
                  : AppTheme.mediumGray.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                isAvailable ? icon : Icons.close,
                size: 16,
                color: isAvailable ? AppTheme.success : AppTheme.mediumGray,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isAvailable ? AppTheme.success : AppTheme.mediumGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
