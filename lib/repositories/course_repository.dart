import '../models/course.dart';
import '../services/course_service.dart';

class CourseRepository {
  final CourseService service;

  CourseRepository(this.service);

  Future<List<Course>> getCourses() {
    return service.loadCourses();
  }

  Future<Map<String, dynamic>> getData() {
    return service.loadData();
  }

  Future<Map<String, dynamic>> getStudent() async {
    final data = await getData();
    return data['student'] as Map<String, dynamic>;
    }
}