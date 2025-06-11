import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/salon_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/salon_card.dart';
import '../widgets/search_filters.dart';
import '../../../core/services/connectivity_service.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SalonProvider>(context, listen: false).loadSalons();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final connectivityService = Provider.of<ConnectivityService>(context);
    connectivityService.addListener(() {
      if (mounted) {
        ConnectivityService.showConnectivitySnackBar(
          context, 
          connectivityService.isConnected
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(
        title: const Text('Salones Disponibles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.go('/client-profile'),
          ),
        ],
      ),
      body: Column(
        children: [
          const SearchFilters(),
          Expanded(
            child: Consumer<SalonProvider>(
              builder: (context, salonProvider, child) {
                if (salonProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGold),
                    ),
                  );
                }

                if (salonProvider.salons.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppTheme.mediumGray,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No se encontraron salones',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppTheme.mediumGray,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Intenta ajustar los filtros de búsqueda',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: salonProvider.salons.length,
                  itemBuilder: (context, index) {
                    final salon = salonProvider.salons[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SalonCard(
                        salon: salon,
                        onTap: () => context.go('/salon-detail/${salon.id}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
