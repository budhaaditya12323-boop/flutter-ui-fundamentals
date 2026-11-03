import 'package:flutter/material.dart';
import '../../screen/layouts/compact_layout.dart';
import '../../screen/layouts/expanded_layout.dart';
import '../../screen/layouts/medium_layout.dart';

class HomeTab extends StatelessWidget {
  final String nama;
  final String nim;

  const HomeTab({super.key, required this.nama, required this.nim});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer - Home'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // physics: const AlwaysScrollableScrollPhysics(), 
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    return CompactLayout(nama: nama, nim: nim);
                  } else if (constraints.maxWidth < 840) {
                    return MediumLayout(nama: nama, nim: nim);
                  } else {
                    return ExpandedLayout(nama: nama, nim: nim);
                  }
                },
              ),
              const Icon(Icons.home, size: 64, color: Colors.blue),
              const SizedBox(height: 16),
              const Text('Selamat Datang!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('$nama - $nim',
                  style: const TextStyle(fontSize: 14)),
            ],
          ),
        )
      ),
    );
  }
}