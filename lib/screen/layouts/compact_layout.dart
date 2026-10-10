// import 'package:flutter_ui_fundamentals/main.dart';
import 'package:flutter/material.dart';

class CompactLayout extends StatelessWidget {
  final String nama;
  final String nim;
  const CompactLayout({super.key, required this.nama, required this.nim});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.phone_android, size: 64),
        const SizedBox(height: 12),
        Text('$nama - $nim',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Chip(
          label: Text('Compact Layout'),
          backgroundColor: Color.fromARGB(60, 210, 210, 210),
          labelStyle: TextStyle(),
        ),
      ],
    );
  }
}