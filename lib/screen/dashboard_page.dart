import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
// import '../services/course_service.dart';
// import '../repositories/course_repository.dart';
import '../providers/course_provider.dart'; 
import '../models/course.dart';
import 'main_shell.dart'; 


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  final String nama = 'I Putu Budha Aditya';
  final String nim = '2415051006';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // late Future<Map<String, dynamic>> studentFuture;
  late Future<List<Course>> coursesFuture;

  @override
  void initState() {
    super.initState();
    // final repository = CourseRepository(CourseService());
    // studentFuture = repository.getStudent();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseProvider>().loadCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Consumer<CourseProvider>(
        builder: (context, provider, child) {
        
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Gagal memuat data:\n${provider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CourseProvider>().loadCourses();
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          return MainShell(
            nama: widget.nama,
            nim: widget.nim,
          );
        },
      ),
    );
  }
}
