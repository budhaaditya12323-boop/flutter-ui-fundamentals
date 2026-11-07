import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/course_provider.dart';
import '../../widgets/course_grid.dart';

class CoursesTab extends StatelessWidget { 
  final String nama;
  final String nim;

  const CoursesTab({
    super.key,
    required this.nama,
    required this.nim,
  });

  @override
  Widget build(BuildContext context) {
    final courses = context.watch<CourseProvider>().courses;
    final int selesai = courses.where((c) => c.status == 'done').length;
    final int aktif = courses.where((c) => c.status == 'active').length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer - Courses'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('$nama - $nim',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('$selesai dari ${courses.length} topik selesai, $aktif sedang aktif',
                style: const TextStyle(fontSize: 16, color: Colors.blue)),
            Consumer<CourseProvider>(
              builder: (context, state, child) {
                return Text(
                  'Total Favorite: ${state.favorites.length}',
                  style: const TextStyle(fontSize: 16, color: Colors.pink),
                );
              },
            ),
            CourseGrid(nama: nama, nim: nim), // ← Hapus parameter courses
          ],
        ),
      ),
    );
  }
}