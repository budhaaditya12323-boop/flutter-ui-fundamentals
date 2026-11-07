import 'package:flutter/material.dart';
import '../models/course.dart';


class CourseDetailPage extends StatefulWidget {
  final Course course;
  final String nama;
  final String nim;
  final bool isFavorite;   // ← terima state awal

  const CourseDetailPage({
    super.key,
    required this.course,
    required this.nama,
    required this.nim,
    required this.isFavorite,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;   // ← init dari state awal
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final nama = widget.nama;
    final nim = widget.nim;

    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── IDENTITAS ───
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 32),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(nama,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(nim, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ─── DETAIL COURSE ───
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Code: ${course.code}'),
                    Text('Credits: ${course.credits} SKS'),
                    Icon(Icons.check_circle_rounded, size: 40, color: course.status == 'planned' ? const Color(0xFF9E9E9E) : course.status == 'done' ? Colors.green : Colors.orange),
                    Text('Status: ${course.status}'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ─── TOMBOL FAVORITE TOGGLE ───
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;   // ← TOGGLE
                  });
                },
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                label: Text(
                  _isFavorite ? 'Hapus dari Favorite' : 'Tambah ke Favorite',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFavorite ? Colors.pink : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ─── TOMBOL KEMBALI + KIRIM HASIL ───
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context, _isFavorite);   // ← KIRIM state
                },
                child: const Text('Kembali'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
