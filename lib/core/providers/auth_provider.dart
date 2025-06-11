import 'package:flutter/material.dart';
import '../models/user.dart';
import '../service/mock_data_service.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  AuthProvider() {
    _loadStoredUser();
  }

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  Future<bool> login(String email, String password, UserType userType) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));

      final user = MockDataService.mockUsers.firstWhere(
            (user) =>
        user.email == email &&
            user.password == password &&
            user.userType == userType,
      );

      _currentUser = user;
      await StorageService.saveUser(_currentUser!);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error en login: ${e.toString()}');
      return false;
    }
  }

  Future<bool> register(String name, String email, String password, String phone, UserType userType) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));

      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        phone: phone,
        password: password,
        userType: userType,
        createdAt: DateTime.now(),
      );

      _currentUser = newUser;
      await StorageService.saveUser(_currentUser!);
      MockDataService.mockUsers.add(newUser);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await StorageService.removeUser();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> _loadStoredUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final storedUser = await StorageService.getUser();
      if (storedUser != null) {
        _currentUser = storedUser;
      }
    } catch (e) {
      print('Error al cargar usuario: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
