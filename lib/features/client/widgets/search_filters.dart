import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/salon_provider.dart';
import '../../../core/theme/app_theme.dart';

class SearchFilters extends StatefulWidget {
  const SearchFilters({super.key});

  @override
  State<SearchFilters> createState() => _SearchFiltersState();
}

class _SearchFiltersState extends State<SearchFilters> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Barra de búsqueda
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar salones...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.tune),
                onPressed: _showFiltersBottomSheet,
              ),
            ),
            onChanged: (value) {
              Provider.of<SalonProvider>(context, listen: false).searchSalons(value);
            },
          ),
          const SizedBox(height: 12),
          // Filtros rápidos
          Consumer<SalonProvider>(
            builder: (context, salonProvider, child) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'Todos',
                      isSelected: salonProvider.selectedLocation.isEmpty,
                      onTap: () => salonProvider.filterByLocation(''),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Polanco',
                      isSelected: salonProvider.selectedLocation == 'Polanco, CDMX',
                      onTap: () => salonProvider.filterByLocation('Polanco, CDMX'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Santa Fe',
                      isSelected: salonProvider.selectedLocation == 'Santa Fe, CDMX',
                      onTap: () => salonProvider.filterByLocation('Santa Fe, CDMX'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Roma Norte',
                      isSelected: salonProvider.selectedLocation == 'Roma Norte, CDMX',
                      onTap: () => salonProvider.filterByLocation('Roma Norte, CDMX'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showFiltersBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _FiltersBottomSheet(),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGold : AppTheme.lightGray,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGold : AppTheme.mediumGray,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.white : AppTheme.darkGray,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _FiltersBottomSheet extends StatefulWidget {
  const _FiltersBottomSheet();

  @override
  State<_FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<_FiltersBottomSheet> {
  double _maxPrice = 50000;
  int _minCapacity = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filtros',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextButton(
                onPressed: () {
                  Provider.of<SalonProvider>(context, listen: false).clearFilters();
                  Navigator.pop(context);
                },
                child: const Text('Limpiar'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Precio máximo',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Slider(
            value: _maxPrice,
            min: 10000,
            max: 50000,
            divisions: 8,
            label: '\$${_maxPrice.toInt()}',
            onChanged: (value) {
              setState(() {
                _maxPrice = value;
              });
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Capacidad mínima',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Slider(
            value: _minCapacity.toDouble(),
            min: 0,
            max: 500,
            divisions: 10,
            label: '${_minCapacity} personas',
            onChanged: (value) {
              setState(() {
                _minCapacity = value.toInt();
              });
            },
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final salonProvider = Provider.of<SalonProvider>(context, listen: false);
                salonProvider.filterByPrice(_maxPrice);
                salonProvider.filterByCapacity(_minCapacity);
                Navigator.pop(context);
              },
              child: const Text('Aplicar Filtros'),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
