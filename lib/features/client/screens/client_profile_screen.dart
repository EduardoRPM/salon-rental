import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../config/theme/app_theme.dart';
import '../../../providers/auth_provider.dart';

class ClientProfileScreen extends StatelessWidget {
  const ClientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil del Cliente'),
      ),
      body: const Center(
        child: Text('Información del perfil del cliente'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Provider.of<AuthProvider>(context, listen: false).logout();
          context.go('/user-type');
        },
        icon: const Icon(Icons.logout),
        label: const Text('Cerrar sesión'),
        backgroundColor: AppTheme.primaryNavy,
      ),
    );
  }
}
