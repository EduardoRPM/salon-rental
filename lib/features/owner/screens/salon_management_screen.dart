import 'package:flutter/material.dart';

/// Pantalla para la administración del salón del dueño.
class SalonManagementScreen extends StatelessWidget {
  const SalonManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Salón'),
      ),
      body: const Center(
        child: Text('Pantalla de gestión del salón'),
      ),
    );
  }
}
