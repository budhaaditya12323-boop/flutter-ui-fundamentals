// import tidak ada import material.dart karena ini bukan widget, tapi service. Jadi tidak perlu import material.dart
import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;
import '../models/course.dart';
import 'package:http/http.dart' as http;

class CourseService {
  final String _apiUrl = 'https://course-api-pearl.vercel.app/courses';
  Future<List<Course>> fetchCourses() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        return data.map((json) => Course.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal memuat data: $e');
    }
  }
}


// class CourseService {
//   Future<Map<String, dynamic>> loadData() async {
//     final jsonString = await rootBundle.loadString(
//       'assets/data/student_data.json',

//       // simulasi nama file JSON yang salah untuk menguji error handling
//       // 'assets/data/course_datddda.json',
//     );
//     return jsonDecode(jsonString) as Map<String, dynamic>;
//   }

//   Future<List<Course>> loadCourses() async {
//     final data = await loadData();
//     final list = data['courses'] as List<dynamic>;
//     return list
//         .map((e) => Course.fromJson(e as Map<String, dynamic>))
//         .toList();
//   }
// }