import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'screen/layouts/compact_layout.dart';
import 'screen/layouts/expanded_layout.dart';
import 'screen/layouts/medium_layout.dart';

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

// ─── TAHAP 7: HomePage Unused ───
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'I Putu Budha Aditya - 2415051006',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // ← Tombol ke DashboardPage
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardPage(),
                  ),
                );
              },
              child: const Text('Buka Dashboard'),
            ),
            const SizedBox(height: 12),

            // Tombol ke DetailPage
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DetailPage(),
                  ),
                );
              },
              child: const Text('Buka Detail'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── TAHAP 7: DetailPageUnused ───
class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'I Putu Budha Aditya - 2415051006',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ini adalah halaman Detail',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}

// Change Navbar Val
class MainShell extends StatefulWidget {
  final String nama;
  final String nim;
  final List<dynamic> courses;

  const MainShell({
    super.key,
    required this.nama,
    required this.nim,
    required this.courses,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeTab(nama: widget.nama, nim: widget.nim, courses: widget.courses),
      CoursesTab(
        courses: widget.courses,
        nama: widget.nama,
        nim: widget.nim,
      ),
      ProfileTab(nama: widget.nama, nim: widget.nim),
    ];

    return LayoutBuilder(                          // ← TAHAP 11
      builder: (context, constraints) {
        // ─── COMPACT / MEDIUM (< 840) ───
        if (constraints.maxWidth < 840) {
          return Scaffold(
            body: pages[_currentIndex],            // ← page yang sama
            bottomNavigationBar: NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() => _currentIndex = index);
              },
              destinations: _destinations,
            ),
          );
        }

        // ─── EXPANDED (>= 840) ───
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: _currentIndex,
                onDestinationSelected: (index) {
                  setState(() => _currentIndex = index);
                },
                labelType: NavigationRailLabelType.all,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.school_outlined),
                    selectedIcon: Icon(Icons.school),
                    label: Text('Courses'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person_outline),
                    selectedIcon: Icon(Icons.person),
                    label: Text('Profile'),
                  ),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(child: pages[_currentIndex]),   // ← page yang sama
            ],
          ),
        );
      },
    );
  }

  // ← destinations untuk NavigationBar
  static const List<NavigationDestination> _destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.school_outlined),
      selectedIcon: Icon(Icons.school),
      label: 'Courses',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];
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
    // final size = MediaQuery.of(context).size;
    // final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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

          return MainShell(
            nama: nama,
            nim: nim,
            courses: courses,
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

// ─── TAHAP 5: CourseCard ───
class CourseCard extends StatefulWidget {
  final Map<String, dynamic> course;
  final String nama;
  final String nim;

  const CourseCard({
    super.key,
    required this.course,
    required this.nama,
    required this.nim,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool _isFavorite = false;   // ← STATE FAVORITE

  @override
  Widget build(BuildContext context) {
    final bool done = widget.course['done'] == true;

    return Card(
      elevation: 2,
      child: InkWell(
        // ─── TAP: buka detail ───
        onTap: () async {
          if (ModalRoute.of(context)?.isCurrent != true) return;

          final messenger = ScaffoldMessenger.of(context);
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => CourseDetailPage(
                course: widget.course,
                nama: widget.nama,
                nim: widget.nim,
                isFavorite: _isFavorite,
              ),
            ),
          );
          if (result == true) {
            messenger.showSnackBar(
              SnackBar(
                content: Text('${widget.course['title']} ditambahkan ke favorite!'),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (result != null) {                    // ← TERIMA hasil
            setState(() {
              _isFavorite = result;                // ← update state
            });
          }
          
        },

        // ─── LONG PRESS: info ───
        onLongPress: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Info: ${widget.course['title']} — ${widget.course['credits']} SKS'),
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
              // ─── Icon + Code + FAVORITE ───
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    done ? Icons.check_circle : Icons.circle_outlined,
                    color: done ? Colors.green : Colors.grey,
                  ),
                  Row(
                    children: [
                      Text(
                        widget.course['code'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      // ─── TOMBOL FAVORITE ───
                      IconButton(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.pink : Colors.grey,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),

              // ─── Title ───
              Text(
                widget.course['title'] as String,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // ─── Credits + Status ───
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.course['credits']} SKS',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    done ? 'Selesai' : 'Belum',
                    style: TextStyle(
                      fontSize: 12,
                      color: done ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
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

class CourseDetailPage extends StatefulWidget {
  final Map<String, dynamic> course;
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
    final bool done = course['done'] == true;

    return Scaffold(
      appBar: AppBar(
        title: Text(course['title'] as String),
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
                      course['title'] as String,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Code: ${course['code']}'),
                    Text('Credits: ${course['credits']} SKS'),
                    Text('Instructor: ${course['instructor']}'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          done ? Icons.check_circle : Icons.schedule,
                          color: done ? Colors.green : Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          done ? 'Selesai' : 'Belum Selesai',
                          style: TextStyle(
                            color: done ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

// ─── TAHAP 5: CourseGrid Responsif ───
class CourseGrid extends StatelessWidget {
  final List<dynamic> courses;
  final String nama;
  final String nim;

  const CourseGrid({
    super.key,
    required this.courses,
    required this.nama,
    required this.nim,
  });

  // ← TAMBAHKAN method ini
  int _columnsFor(double width) {
    if (width < 600) return 1;
    if (width < 840) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final int selesai = courses.where((c) => c['done'] == true).length;   // ← HITUNG dulu

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
                    final course = courses[index] as Map<String, dynamic>;
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

// ─── Compact Layout (< 600) ───


// ─── Medium Layout (600–839) ───


// ─── Expanded Layout (>= 840) ───


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

// Feedback Form
class FeedbackForm extends StatefulWidget {
  final String nama;
  final String nim;

  const FeedbackForm({
    super.key,
    required this.nama,
    required this.nim,
  });

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaController;
  late TextEditingController _nimController;
  final TextEditingController _komentarController = TextEditingController();

  bool _isLoading = false;   // ← TAHAP 14, loading state

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.nama);
    _nimController = TextEditingController(text: widget.nim);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _komentarController.dispose();
    super.dispose();
  }

  // ─── SUBMIT, dengan Dialog + Loading + SnackBar ───
  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // ─── TAHAP 14, AlertDialog Konfirmasi ───
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Kirim feedback ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);   // ← tutup dialog
              _prosesSubmit();                // ← proses
            },
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }

  // ─── PROSES, dengan Loading + SnackBar ───
  Future<void> _prosesSubmit() async {
    setState(() => _isLoading = true);   // ← tampilkan loading

    final messenger = ScaffoldMessenger.of(context);

    // ─── Simulasi loading 2 detik ───
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);  // ← sembunyikan loading

    // ─── TAHAP 14, SnackBar ───
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Feedback berhasil dikirim!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── HEADER ───
            const Text(
              'Feedback Form',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // ─── NAMA ───
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ─── NIM ───
            TextFormField(
              controller: _nimController,
              decoration: const InputDecoration(
                labelText: 'NIM',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'NIM wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ─── KOMENTAR ───
            TextFormField(
              controller: _komentarController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Komentar',
                border: OutlineInputBorder(),
                hintText: 'Tulis komentar minimal 5 karakter',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Komentar wajib diisi';
                }
                if (value.trim().length < 5) {
                  return 'Komentar minimal 5 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // ─── TOMBOL SUBMIT, dengan Loading ───
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,   // ← disable saat loading
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Kirim Feedback'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//New Pages
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
            // Kasus C: Keyboard
            // Sebelum: Form tanpa SingleChildScrollView , saat keyboard muncul ,
            //          form tertutup keyboard , user tidak bisa akses field.
            // Sesudah: Form dibungkus SingleChildScrollView , saat keyboard muncul ,
            //          form bisa discroll , user tetap bisa akses field
          ],
        ),
      ),
    );
  }
}

class CoursesTab extends StatelessWidget {
  final List<dynamic> courses;
  final String nama;
  final String nim;

  const CoursesTab({
    super.key,
    required this.courses,
    required this.nama,
    required this.nim,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer - Courses'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('$nama - $nim',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            CourseGrid(
              courses: courses,
              nama: nama,
              nim: nim,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  final String nama;
  final String nim;
  final List<dynamic> courses;

  const HomeTab({super.key, required this.courses, required this.nama, required this.nim});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer - Home'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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

            //Kasus A: RenderFlex Overflow
            // Wrap(
            //   children: [
            //     const Icon(Icons.info),
            //     const SizedBox(width: 8),
            //     Text('$nim - $nama - teks sangat panjang banget banget banget banget banget banget banget banget banget banget banget bangetbanget banget banget banget banget bangetbanget banget banget banget banget banget'),
            //   ],
            // )

            //Kasus B: Vertical viewport was given unbounded height
            // Column(
            //   children: [
            //     ListView.builder(
            //       shrinkWrap: true,
            //       physics: const NeverScrollableScrollPhysics(),
            //       itemCount: courses.length,
            //       itemBuilder: (context, index) {
            //         final course = courses[index] as Map<String, dynamic>;
            //         return ListTile(
            //           title: Text(course['title'] as String),
            //         );
            //       },
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}