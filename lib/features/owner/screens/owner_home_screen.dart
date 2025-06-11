import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/providers/booking_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/booking.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.currentUser != null) {
        Provider.of<BookingProvider>(context, listen: false)
            .loadBookings(authProvider.currentUser!.id, isOwner: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Implementar notificaciones
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Implementar configuración
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saludo y estadísticas rápidas
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hola, ${authProvider.currentUser?.name ?? 'Usuario'}',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Aquí tienes un resumen de tu actividad',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Estadísticas principales
            Consumer<BookingProvider>(
              builder: (context, bookingProvider, child) {
                final pendingBookings = bookingProvider.bookings
                    .where((b) => b.status == BookingStatus.pending)
                    .length;
                final confirmedBookings = bookingProvider.bookings
                    .where((b) => b.status == BookingStatus.confirmed)
                    .length;
                final totalRevenue = bookingProvider.bookings
                    .where((b) => b.status == BookingStatus.confirmed)
                    .fold(0.0, (sum, booking) => sum + booking.totalAmount);

                return Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Solicitudes\nPendientes',
                        value: pendingBookings.toString(),
                        icon: Icons.pending_actions,
                        color: AppTheme.primaryGold,
                        onTap: () => context.go('/requests'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: 'Reservas\nConfirmadas',
                        value: confirmedBookings.toString(),
                        icon: Icons.event_available,
                        color: AppTheme.success,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: 'Ingresos\nEste Mes',
                        value: '\$${(totalRevenue / 1000).toStringAsFixed(0)}K',
                        icon: Icons.attach_money,
                        color: AppTheme.primaryNavy,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Calendario de reservas
            Text(
              'Calendario de Reservas',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 12),
            Consumer<BookingProvider>(
              builder: (context, bookingProvider, child) {
                final confirmedBookings = bookingProvider.bookings
                    .where((b) => b.status == BookingStatus.confirmed)
                    .toList();

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TableCalendar<Booking>(
                      firstDay: DateTime.now().subtract(const Duration(days: 30)),
                      lastDay: DateTime.now().add(const Duration(days: 365)),
                      focusedDay: DateTime.now(),
                      eventLoader: (day) {
                        return confirmedBookings.where((booking) {
                          return isSameDay(booking.eventDate, day);
                        }).toList();
                      },
                      calendarStyle: const CalendarStyle(
                        markersMaxCount: 3,
                        markerDecoration: BoxDecoration(
                          color: AppTheme.primaryGold,
                          shape: BoxShape.circle,
                        ),
                      ),
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Gráfico de ingresos
            Text(
              'Ingresos Mensuales',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            const FlSpot(0, 20),
                            const FlSpot(1, 35),
                            const FlSpot(2, 25),
                            const FlSpot(3, 45),
                            const FlSpot(4, 30),
                            const FlSpot(5, 50),
                          ],
                          isCurved: true,
                          color: AppTheme.primaryGold,
                          barWidth: 3,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppTheme.primaryGold.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Acciones rápidas
            Text(
              'Acciones Rápidas',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    title: 'Gestionar Salón',
                    subtitle: 'Editar información y fotos',
                    icon: Icons.edit,
                    onTap: () => context.go('/salon-management'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionCard(
                    title: 'Ver Solicitudes',
                    subtitle: 'Revisar nuevas reservas',
                    icon: Icons.inbox,
                    onTap: () => context.go('/requests'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 32,
                color: AppTheme.primaryGold,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
