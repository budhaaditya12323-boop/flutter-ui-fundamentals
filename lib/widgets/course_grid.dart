import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import 'course_card.dart';

class CourseGrid extends StatelessWidget {
  final String nama;
  final String nim;

  const CourseGrid({
    super.key,
    required this.nama,
    required this.nim,
  });

  int _columnsFor(double width) {
    if (width < 600) return 1;
    if (width < 840) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final courses = context.watch<CourseProvider>().courses;
    final int selesai = courses.where((c) => c.done).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('$selesai dari ${courses.length} topik selesai'),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _columnsFor(constraints.maxWidth),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.6,
                  ),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return CourseCard(
                      course: course,
                      nama: nama,
                      nim: nim,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}