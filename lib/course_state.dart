// lib/course_state.dart
import 'package:flutter/material.dart';

class CourseState extends ChangeNotifier {
  // 23. Collection favorites
  final Set<String> favorites = {};

  // 24. Method toggleFavorite
  void toggleFavorite(String id) {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    
    // 25. Panggil notifyListeners() setiap kali state berubah
    notifyListeners(); 
  }

  // Helper untuk mengecek apakah suatu course sudah di-favorite
  bool isFavorite(String id) => favorites.contains(id);
}