import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import 'course_detail_page.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final String nama;
  final String nim;

  const CourseCard({
    super.key,
    required this.course,
    required this.nama,
    required this.nim,
  });

  @override
  Widget build(BuildContext context) {
    final String code = course.code;
    // Cek status langsung dari CourseState
    final courseState = context.watch<CourseProvider>(); 
    final bool isFav = courseState.isFavorite(code);

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () async {
          if (ModalRoute.of(context)?.isCurrent != true) return;

          final messenger = ScaffoldMessenger.of(context);
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => CourseDetailPage(
                course: course,
                nama: nama,
                nim: nim,
                isFavorite: isFav,
              ),
            ),
          );
          
          if (result != null) {
            // Panggil method dari state langsung
            if (context.mounted) {
              context.read<CourseProvider>().toggleFavorite(code);
            }
            messenger.showSnackBar(
              SnackBar(
                content: Text('$code ${result ? 'ditambahkan ke' : 'dihapus dari'} favorite!'),
                backgroundColor: result ? Colors.green : Colors.grey,
              ),
            );
          }
        },
        onLongPress: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Info: ${course.title} — ${course.credits} SKS'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        code,
                        style: const TextStyle(
                          fontSize: 12,
                              color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.check_circle_rounded, size: 20, color: course.status == 'planned' ? const Color(0xFF9E9E9E) : course.status == 'done' ? Colors.green : Colors.orange),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.pink : Colors.grey,
                      size: 20,
                    ),
                    onPressed: () {
                      // Panggil method dari state langsung
                      context.read<CourseProvider>().toggleFavorite(code);
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              Text(
                course.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${course.credits} SKS',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}