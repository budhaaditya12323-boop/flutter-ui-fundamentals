import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/course_provider.dart';
import '../../widgets/course_card.dart'; 

class FavoritesPage extends StatelessWidget {
  final String nama;
  final String nim;

  const FavoritesPage({
    super.key,
    required this.nama,
    required this.nim,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Courses'),
        centerTitle: true,
      ),
      body: Consumer<CourseProvider>(
        builder: (context, provider, child) {
          final favoriteCourses = provider.courses
              .where((course) => provider.isFavorite(course.code))
              .toList();

          if (favoriteCourses.isEmpty) {
            return const Center(
              child: Text('Belum ada course yang di-favorite.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoriteCourses.length,
            itemBuilder: (context, index) {
              final course = favoriteCourses[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: 
                Column(
                  children: [
                    Text('$nama - $nim', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    CourseCard(
                      course: course,
                      nama: nama,
                      nim: nim,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}