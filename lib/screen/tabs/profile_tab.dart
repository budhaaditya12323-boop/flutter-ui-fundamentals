import 'package:flutter/material.dart';
import '../../widgets/feedback_form.dart';

class ProfileTab extends StatelessWidget {
  final String nama;
  final String nim;

  const ProfileTab({super.key, required this.nama, required this.nim});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer - Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/profile.jpeg'),
            ),
            const SizedBox(height: 16),
            Text(nama,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(nim, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            const Icon(Icons.school, size: 48, color: Colors.blue),
            FeedbackForm(nama: nama, nim: nim),
          ],
        ),
      ),
    );
  }
}