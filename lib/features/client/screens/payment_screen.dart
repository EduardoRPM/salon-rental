import 'package:flutter/material.dart';

/// Pantalla básica para el proceso de pago.
class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago'),
      ),
      body: const Center(
        child: Text('Pantalla de pago'),
      ),
    );
  }
}
