import 'package:flutter/material.dart';

/// Pantalla que muestra las solicitudes de reserva recibidas.
class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitudes'),
      ),
      body: const Center(
        child: Text('Listado de solicitudes'),
      ),
    );
  }
}
