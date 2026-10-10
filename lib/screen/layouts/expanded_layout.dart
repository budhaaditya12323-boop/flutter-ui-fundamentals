import 'package:flutter/material.dart';

class ExpandedLayout extends StatelessWidget {
  final String nama;
  final String nim;
  const ExpandedLayout({super.key, required this.nama, required this.nim});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.desktop_windows, size: 64),
        const SizedBox(width: 16),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$nama - $nim',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Chip(
              label: Text('Expanded Layout'),
              backgroundColor: Color.fromARGB(60, 210, 210, 210),
            ),
          ],
        ),
      ],
    );
  }
}