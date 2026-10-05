import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

// ─── Baca JSON ───
Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
    //'assets/data/student_dataa.json', -- simulasi kasus json salah direktori
  );
  return jsonDecode(jsonString) as Map<String, dynamic>;
}

// ─── MyApp ───
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DashboardPage(),
    );
  }
}

// ─── DashboardPage — StatefulWidget + FutureBuilder ───
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
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Learning Dashboard',                          // ← judul baru
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {

          // ─── LOADING ───
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ─── ERROR ───
          if (snapshot.hasError) {
            return Center(
              child: Text('Gagal memuat data: ${snapshot.error}'),
            );
          }

          // ─── DATA ───
          final data = snapshot.data!;
          final student = data['student'] as Map<String, dynamic>;
          final courses = data['courses'] as List<dynamic>;

          final String nim = student['nim'] as String;
          final String nama = student['name'] as String;
          final String program = student['program'] as String? ?? '-';

          final int selesai = courses.where((c) => c['done'] == true).length;
          final int totalSks = courses.fold<int>(
            0,
            (sum, c) => sum + (c['credits'] as int),
          );

          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // ─── TAHAP 4: EXPANDED FLEX 2:1 ───
                    const Text('Expanded Flex 2:1',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: buildBox('A', Colors.blue),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: buildBox('B', Colors.orange),
                        ),
                      ],
                    ),

                    // ─── TAHAP 4: WRAP CHIP ───
                    const SizedBox(height: 16),
                    const Text('Wrap — Skill Chips',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        Chip(label: Text('Flutter')),
                        Chip(label: Text('Dart')),
                        Chip(label: Text('Git')),
                        Chip(label: Text('Website')),
                        Chip(label: Text('Mobile')),
                        Chip(label: Text('Laravel')),
                        Chip(label: Text('Tailwind')),
                      ],
                    ),
                    
                    // Chip Dengan Row Biasa
                    const SizedBox(height: 16),
                    const Text('Row — Skill Chips',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8,
                      children: const [
                        Chip(label: Text('Flutter')),
                        Chip(label: Text('Dart')),
                        Chip(label: Text('Git')),
                        Chip(label: Text('Website')),
                        Chip(label: Text('Mobile')),
                        Chip(label: Text('Laravel')),
                        Chip(label: Text('Tailwind')),
                      ],
                    ),

                  // Layout Builder
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

                    // Test Overflow
                    // Container(
                    //   child:
                    //     Container(
                    //       width: double.infinity,
                    //       padding: const EdgeInsets.all(16),
                    //       child: Text('$nama - $nim'),
                    //     ),
                    // ),
                    
                    // Test Media Query
                    Text('Width: ${size.width.toStringAsFixed(0)}'),
                    Text('Height: ${size.height.toStringAsFixed(0)}'),
                    Text('Orientation: $orientation / ${size.width < 600 ? 'Compact' : 'Wide'}}'),
                    Text('$nama - $nim'),

                    // ─── PROFIL ───
                    ProfileCard(
                      nama: nama,
                      nim: nim,
                      program: program,
                    ),
                    const SizedBox(height: 16),

                    // ─── SUMMARY (2 card: topik & SKS) ───
                    SummaryRow(
                      totalTopik: courses.length,
                      totalSks: totalSks,
                      selesai: selesai,
                    ),
                    const SizedBox(height: 16),

                    // ─── LIST COURSES ───
                    CourseList(courses: courses),
                    const SizedBox(height: 16),

                    // ─── GREETING (StatefulWidget) ───
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: 350,
                          child: GreetingCard(nim: nim, nama: nama),
                        ),
                      ),
                    ),
                    Card(
                      // child: Row(
                      //   children: [
                      //     const Icon(Icons.info),
                      //     const SizedBox(width: 8),
                      //     Text('$nama - $nim - Ini adalah teks yang sangat panjang untuk menguji layout'),
                      //   ],
                      // )                  SIMULASI OVERFLOW
                      child: Row(
                        children: [
                          const Icon(Icons.info),
                          const SizedBox(width: 8),
                          Expanded(                              // ← tambahkan
                            child: Text('$nama - $nim - Ini adalah teks yang sangat panjang untuk menguji layout'),
                          ),
                        ],
                      )
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

// ─── REUSABLE 1: ProfileCard ───
class ProfileCard extends StatelessWidget {
  final String nama;
  final String nim;
  final String program;

  const ProfileCard({
    super.key,
    required this.nama,
    required this.nim,
    required this.program,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
                Text(program, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── REUSABLE 2: SummaryRow ───
class SummaryRow extends StatelessWidget {
  final int totalTopik;
  final int totalSks;
  final int selesai;

  const SummaryRow({
    super.key,
    required this.totalTopik,
    required this.totalSks,
    required this.selesai,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildStatCard(totalTopik.toString(), 'Topik', Icons.book),
          buildStatCard(totalSks.toString(), 'SKS', Icons.school),
          buildStatCard(selesai.toString(), 'Selesai', Icons.check_circle),
        ],
      ),
    );
  }
}

// ─── Reusable function: buildStatCard ───
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

// ─── REUSABLE 3: CourseList ───
class CourseList extends StatelessWidget {
  final List<dynamic> courses;

  const CourseList({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    final int selesai = courses.where((c) => c['done'] == true).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: 350,
          child: Column(
            children: [
              Text(
                '$selesai dari ${courses.length} topik selesai',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
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
                    subtitle: Text(
                      '${course['code']} • ${course['credits']} SKS • ${course['instructor']}',
                    ),
                    trailing: Text(
                      done ? 'Selesai' : 'Belum',
                      style: TextStyle(color: done ? Colors.green : Colors.grey),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Compact Layout (< 600) ───
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

// ─── Medium Layout (600–839) ───
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

// ─── Expanded Layout (>= 840) ───
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

// ─── GreetingCard — StatefulWidget ───
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

// ─── Reusable: buildBox ───
Widget buildBox(String label, Color color) {
  return Container(
    height: 80,
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.3),
      border: Border.all(color: color, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Text(
        label,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    ),
  );
}

