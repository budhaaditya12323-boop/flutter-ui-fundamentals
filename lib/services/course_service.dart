import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/course.dart';

class CourseService {
  Future<Map<String, dynamic>> loadData() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/student_data.json',

      // simulasi nama file JSON yang salah untuk menguji error handling
      // 'assets/data/course_datddda.json',
    );
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Future<List<Course>> loadCourses() async {
    final data = await loadData();
    final list = data['courses'] as List<dynamic>;
    return list
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}