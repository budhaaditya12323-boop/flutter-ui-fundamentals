import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

const String studentName = 'I Putu Budha Aditya';
const String studentId = '2415051006';

// ─── Fungsi baca JSON ───
Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );
  return jsonDecode(jsonString) as Map<String, dynamic>;
}

void main() {
  runApp(const MyApp());
}

// ─── MyApp — root ───
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DashboardPage(),   // ← ganti ke DashboardPage
    );
  }
}

// ─── DashboardPage — StatefulWidget dengan FutureBuilder ───
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();   // ← sekali saja
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Flutter UI Fundamentals',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {

          // 1. LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. ERROR
          if (snapshot.hasError) {
            return Center(
              child: Text('Gagal memuat data: ${snapshot.error}'),
            );
          }

          // 3. DATA
          final data = snapshot.data!;
          final student = data['student'] as Map<String, dynamic>;
          final courses = data['courses'] as List<dynamic>;

          final String nim = student['nim'] as String;
          final String nama = student['name'] as String;
          final int selesai = courses.where((c) => c['done'] == true).length;

          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // ─── CARD 1: PROFIL ───
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 20,
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage('assets/images/profile.jpeg'),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(nama, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                                Text(nim, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ─── CARD 2: DESKRIPSI ───
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: 350,
                          child: Row(
                            spacing: 10,
                            children: [
                              const Expanded(
                                child: Text(
                                  'Saya memiliki minat di pemrograman mobile dan mendalami teknologi flutter',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              const Icon(Icons.code, size: 50),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ─── CARD 3: STATISTIK ───
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: 350,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStatCard(courses.length.toString(), 'Topik', Icons.book),
                              buildStatCard(selesai.toString(), 'Selesai', Icons.check_circle),
                              buildStatCard((courses.length - selesai).toString(), 'Belum', Icons.schedule),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ─── CARD 4: GREETING ───
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: 350,
                          child: GreetingCard(nim: nim, nama: nama),
                        ),
                      ),
                    ),

                    // ─── CARD 5: LIST COURSES DARI JSON ───
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: 350,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text('$nim - $nama'),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: courses.length,
                                itemBuilder: (context, index) {
                                  final course = courses[index] as Map<String, dynamic>;
                                  final bool done = course['done'] == true;
                                  return ListTile(
                                    leading: Icon(
                                      done ? Icons.check_circle : Icons.circle_outlined,
                                      color: done ? Colors.green : Colors.grey,
                                    ),
                                    title: Text(course['title'] as String),
                                    subtitle: Text(course['code'] as String),
                                    trailing: Text(
                                      done ? 'Selesai' : 'Belum',
                                      style: TextStyle(color: done ? Colors.green : Colors.grey),
                                    ),
                                  );
                                },
                              ),
                              Text('$selesai dari ${courses.length} topik selesai!'),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── GreetingCard — StatefulWidget (dipindah ke parameter) ───
class GreetingCard extends StatefulWidget {
  final String nim;
  final String nama;
  const GreetingCard({super.key, required this.nim, required this.nama});

  @override
  State<GreetingCard> createState() => _GreetingCardState();
}

class _GreetingCardState extends State<GreetingCard> {
  final TextEditingController controller = TextEditingController();
  String message = 'Belum Ada Pesan';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${widget.nim} - ${widget.nama}'),
        TextField(controller: controller),
        ElevatedButton(
          onPressed: () {
            setState(() {
              message = controller.text.trim().isEmpty
                  ? 'Input masih kosong'
                  : controller.text.trim();
            });
          },
          child: const Text('Tampilkan'),
        ),
        Text(message),
      ],
    );
  }
}

// ─── Reusable: buildStatCard ───
Widget buildStatCard(String value, String label, IconData icon) {
  return Expanded(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(label),
          ],
        ),
      ),
    ),
  );
}