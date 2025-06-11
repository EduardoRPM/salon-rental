import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/user_type_selection_screen.dart';
import '../../features/client/screens/client_home_screen.dart';
import '../../features/client/screens/salon_detail_screen.dart';
import '../../features/client/screens/booking_request_screen.dart';
import '../../features/client/screens/payment_screen.dart';
import '../../features/client/screens/client_profile_screen.dart';
import '../../features/owner/screens/owner_home_screen.dart';
import '../../features/owner/screens/salon_management_screen.dart';
import '../../features/owner/screens/requests_screen.dart';
import '../../features/shared/screens/chat_screen.dart';
import '../../features/shared/screens/splash_screen.dart';
import '../../features/auth/screens/register_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/user-type',
        builder: (context, state) => const UserTypeSelectionScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) {
          final userType = state.uri.queryParameters['userType'] ?? 'client';
          return LoginScreen(userType: userType);
        },
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) {
          final userType = state.uri.queryParameters['userType'] ?? 'client';
          return RegisterScreen(userType: userType);
        },
      ),
      GoRoute(
        path: '/client-home',
        builder: (context, state) => const ClientHomeScreen(),
      ),
      GoRoute(
        path: '/salon-detail/:id',
        builder: (context, state) {
          final salonId = state.pathParameters['id']!;
          return SalonDetailScreen(salonId: salonId);
        },
      ),
      GoRoute(
        path: '/booking-request/:salonId',
        builder: (context, state) {
          final salonId = state.pathParameters['salonId']!;
          return BookingRequestScreen(salonId: salonId);
        },
      ),
      GoRoute(
        path: '/payment',
        builder: (context, state) => const PaymentScreen(),
      ),
      GoRoute(
        path: '/client-profile',
        builder: (context, state) => const ClientProfileScreen(),
      ),
      GoRoute(
        path: '/owner-home',
        builder: (context, state) => const OwnerHomeScreen(),
      ),
      GoRoute(
        path: '/salon-management',
        builder: (context, state) => const SalonManagementScreen(),
      ),
      GoRoute(
        path: '/requests',
        builder: (context, state) => const RequestsScreen(),
      ),
      GoRoute(
        path: '/chat/:userId',
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          final userName = state.uri.queryParameters['userName'] ?? 'Usuario';
          return ChatScreen(userId: userId, userName: userName);
        },
      ),
    ],
  );
}
