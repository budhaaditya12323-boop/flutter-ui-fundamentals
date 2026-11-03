import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../services/course_service.dart';
import '../repositories/course_repository.dart';
import '../providers/course_provider.dart'; 
import '../models/course.dart';
import 'main_shell.dart'; 


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentFuture;
  late Future<List<Course>> coursesFuture;

  @override
  void initState() {
    super.initState();
    final repository = CourseRepository(CourseService());
    studentFuture = repository.getStudent();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseProvider>().loadCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, studentSnapshot) {
          if (studentSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (studentSnapshot.hasError) {
            return Center(child: Text('Gagal memuat identitas: ${studentSnapshot.error}'));
          }

          final student = studentSnapshot.data!;
          final nama = student['name'] as String? ?? '-';
          final nim = student['nim'] as String? ?? '-';

          return Consumer<CourseProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.error != null) {
                return Center(child: Text('Gagal memuat data: ${provider.error}'));
              }

              return MainShell(
                nama: nama,
                nim: nim,
              );
            },
          );
        },
      ),
    );
  }
}
