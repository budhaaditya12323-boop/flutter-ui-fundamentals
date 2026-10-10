import 'package:flutter/material.dart';

class MediumLayout extends StatelessWidget {
  final String nama;
  final String nim;
  const MediumLayout({super.key, required this.nama, required this.nim});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.screen_rotation, size: 64),
        const SizedBox(width: 16),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$nama - $nim',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Chip(
              label: Text('Medium Layout'),
              backgroundColor: Color.fromARGB(60, 210, 210, 210),
            ),
          ],
        ),
      ],
    );
  }
}