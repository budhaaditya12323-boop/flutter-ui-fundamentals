import 'package:flutter/material.dart';

const String studentName = 'I Putu Budha Aditya';
const String studentId = '2415051006';

void main() {
  runApp(const MyApp());
}

class GreetingCard extends StatefulWidget {
  const GreetingCard({super.key});

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
  } //dispose biar gak memory leak

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$studentId - $studentName'),
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            'Flutter UI Fundamentals',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),       
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ─── CARD 1: PROFIL ───
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 20,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/images/profile.jpeg'),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              studentName,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                            ),
                            Text(
                              studentId,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ─── CARD 2: DESKRIPSI ───
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: 350,
                      child: Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: Text(
                              'Saya memiliki minat di pemrograman mobile dan mendalami teknologi flutter',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          const Icon(Icons.code, size: 50),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ─── CARD 3: STATISTIK ───
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: 350,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildStatCard('30', 'Widget', Icons.widgets),
                          buildStatCard('15', 'Layout', Icons.view_quilt),
                          buildStatCard('0', 'State', Icons.toggle_on),
                        ],
                      ),
                    ),
                  ),
                ),

                // ─── CARD 4: STATEFULL WIDGET ───
                Card(
                  child: Padding(padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: 350,
                      child: GreetingCard()
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}