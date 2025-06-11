import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/providers/salon_provider.dart';
import '../../../core/providers/booking_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/models/booking.dart';
import '../../../core/theme/app_theme.dart';

class BookingRequestScreen extends StatefulWidget {
  final String salonId;

  const BookingRequestScreen({super.key, required this.salonId});

  @override
  State<BookingRequestScreen> createState() => _BookingRequestScreenState();
}

class _BookingRequestScreenState extends State<BookingRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedTime = '18:00';
  String _eventType = 'Boda';
  int _guestCount = 100;
  List<String> _selectedServices = [];
  final _notesController = TextEditingController();

  final List<String> _eventTypes = [
    'Boda',
    'Evento Corporativo',
    'Quinceañera',
    'Aniversario',
    'Graduación',
    'Otro',
  ];

  final List<String> _timeSlots = [
    '10:00', '11:00', '12:00', '13:00', '14:00', '15:00',
    '16:00', '17:00', '18:00', '19:00', '20:00', '21:00',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SalonProvider>(
      builder: (context, salonProvider, child) {
        final salon = salonProvider.getSalonById(widget.salonId);

        if (salon == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Salón no encontrado')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Solicitar Reserva'),
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información del salón
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              salon.images.first,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: AppTheme.lightGray,
                                  child: const Icon(Icons.image),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  salon.name,
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  salon.location,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  NumberFormat.currency(locale: 'es_MX', symbol: '\$')
                                      .format(salon.price),
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppTheme.primaryGold,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Selección de fecha
                  Text(
                    'Fecha del evento',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: TableCalendar<DateTime>(
                        firstDay: DateTime.now(),
                        lastDay: DateTime.now().add(const Duration(days: 365)),
                        focusedDay: _selectedDate,
                        selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDate = selectedDay;
                          });
                        },
                        calendarStyle: const CalendarStyle(
                          selectedDecoration: BoxDecoration(
                            color: AppTheme.primaryGold,
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: BoxDecoration(
                            color: AppTheme.primaryNavy,
                            shape: BoxShape.circle,
                          ),
                        ),
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Selección de hora
                  Text(
                    'Hora del evento',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _timeSlots.map((time) {
                      final isSelected = _selectedTime == time;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTime = time;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primaryGold : AppTheme.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? AppTheme.primaryGold : AppTheme.mediumGray,
                            ),
                          ),
                          child: Text(
                            time,
                            style: TextStyle(
                              color: isSelected ? AppTheme.white : AppTheme.darkGray,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Tipo de evento
                  Text(
                    'Tipo de evento',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _eventType,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.event),
                    ),
                    items: _eventTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _eventType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Número de invitados
                  Text(
                    'Número de invitados',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _guestCount.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.people),
                      suffixText: 'personas',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa el número de invitados';
                      }
                      final count = int.tryParse(value);
                      if (count == null || count <= 0) {
                        return 'Ingresa un número válido';
                      }
                      if (count > salon.capacity) {
                        return 'Máximo ${salon.capacity} personas';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      final count = int.tryParse(value);
                      if (count != null) {
                        setState(() {
                          _guestCount = count;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // Servicios adicionales
                  Text(
                    'Servicios adicionales',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  ...salon.services.map((service) {
                    final isSelected = _selectedServices.contains(service);
                    return CheckboxListTile(
                      title: Text(service),
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedServices.add(service);
                          } else {
                            _selectedServices.remove(service);
                          }
                        });
                      },
                      activeColor: AppTheme.primaryGold,
                    );
                  }).toList(),
                  const SizedBox(height: 24),

                  // Notas adicionales
                  Text(
                    'Notas adicionales',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Describe detalles específicos de tu evento...',
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Resumen del costo
                  Card(
                    color: AppTheme.lightGray,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Resumen de costos',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Renta del salón'),
                              Text(
                                NumberFormat.currency(locale: 'es_MX', symbol: '\$')
                                    .format(salon.price),
                              ),
                            ],
                          ),
                          if (_selectedServices.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Servicios (${_selectedServices.length})'),
                                const Text('Cotización'),
                              ],
                            ),
                          ],
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total estimado',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                NumberFormat.currency(locale: 'es_MX', symbol: '\$')
                                    .format(salon.price),
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryGold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Botón de enviar solicitud
                  SizedBox(
                    width: double.infinity,
                    child: Consumer<BookingProvider>(
                      builder: (context, bookingProvider, child) {
                        return ElevatedButton(
                          onPressed: bookingProvider.isLoading ? null : _submitBookingRequest,
                          child: bookingProvider.isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.white),
                            ),
                          )
                              : const Text('Enviar Solicitud de Reserva'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitBookingRequest() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
      final salonProvider = Provider.of<SalonProvider>(context, listen: false);

      final salon = salonProvider.getSalonById(widget.salonId)!;
      final user = authProvider.currentUser!;

      final booking = Booking(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        salonId: widget.salonId,
        clientId: user.id,
        ownerId: salon.ownerId,
        eventDate: _selectedDate,
        eventTime: _selectedTime,
        eventType: _eventType,
        guestCount: _guestCount,
        additionalServices: _selectedServices,
        totalAmount: salon.price,
        status: BookingStatus.pending,
        createdAt: DateTime.now(),
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      final success = await bookingProvider.createBooking(booking);

      if (success && mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¡Solicitud Enviada!'),
            content: const Text(
              'Tu solicitud de reserva ha sido enviada al propietario del salón. '
                  'Te notificaremos cuando recibas una respuesta.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/client-home');
                },
                child: const Text('Entendido'),
              ),
            ],
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al enviar la solicitud'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }
}
