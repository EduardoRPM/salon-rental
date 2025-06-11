import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';

class StorageService {
  static const String _userKey = 'user_data';

  // Guardar datos del usuario
  static Future<bool> saveUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
        'userType': user.userType == UserType.client ? 'client' : 'owner',
        'createdAt': user.createdAt?.toIso8601String(),
      };
      return await prefs.setString(_userKey, jsonEncode(userData));
    } catch (e) {
      print('Error al guardar usuario: $e');
      return false;
    }
  }

  // Obtener datos del usuario
  static Future<User?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString(_userKey);
      
      if (userString == null) {
        return null;
      }
      
      final userData = jsonDecode(userString);
      return User(
        id: userData['id'],
        name: userData['name'],
        email: userData['email'],
        phone: userData['phone'],
        userType: userData['userType'] == 'client' ? UserType.client : UserType.owner,
        createdAt: userData['createdAt'] != null
            ? DateTime.parse(userData['createdAt'])
            : null,
      );
    } catch (e) {
      print('Error al obtener usuario: $e');
      return null;
    }
  }

  // Eliminar datos del usuario
  static Future<bool> removeUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_userKey);
    } catch (e) {
      print('Error al eliminar usuario: $e');
      return false;
    }
  }
}
