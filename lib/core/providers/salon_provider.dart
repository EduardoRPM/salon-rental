import 'package:flutter/material.dart';
import '../models/salon.dart';
import '../services/mock_data_service.dart';

class SalonProvider with ChangeNotifier {
  List<Salon> _salons = [];
  List<Salon> _filteredSalons = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedLocation = '';
  double _maxPrice = 50000;
  int _minCapacity = 0;

  List<Salon> get salons => _filteredSalons;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedLocation => _selectedLocation;
  double get maxPrice => _maxPrice;
  int get minCapacity => _minCapacity;

  Future<void> loadSalons() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      _salons = MockDataService.mockSalons;
      _filteredSalons = _salons;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchSalons(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void filterByLocation(String location) {
    _selectedLocation = location;
    _applyFilters();
  }

  void filterByPrice(double maxPrice) {
    _maxPrice = maxPrice;
    _applyFilters();
  }

  void filterByCapacity(int minCapacity) {
    _minCapacity = minCapacity;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredSalons = _salons.where((salon) {
      final matchesSearch = _searchQuery.isEmpty ||
          salon.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          salon.location.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesLocation = _selectedLocation.isEmpty ||
          salon.location == _selectedLocation;

      final matchesPrice = salon.price <= _maxPrice;
      final matchesCapacity = salon.capacity >= _minCapacity;

      return matchesSearch && matchesLocation && matchesPrice && matchesCapacity;
    }).toList();

    notifyListeners();
  }

  Salon? getSalonById(String id) {
    try {
      return _salons.firstWhere((salon) => salon.id == id);
    } catch (e) {
      return null;
    }
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedLocation = '';
    _maxPrice = 50000;
    _minCapacity = 0;
    _filteredSalons = _salons;
    notifyListeners();
  }
}
