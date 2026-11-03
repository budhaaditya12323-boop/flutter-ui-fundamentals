import 'package:flutter/material.dart';
import 'services/course_service.dart';
import 'repositories/course_repository.dart';
import 'package:provider/provider.dart'; 
import 'providers/course_provider.dart'; 
import 'my_app.dart';

void main() {
  final courseService = CourseService();
  final courseRepository = CourseRepository(courseService);
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(courseRepository),
      child: const MyApp(),
    ),
  );
}

