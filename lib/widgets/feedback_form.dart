import 'package:flutter/material.dart';

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

    await Future.delayed(const Duration(seconds: 2));
    //jika pengecekan mounted tidak ada, maka akan muncul error "setState() called after dispose()"
    if (!mounted) return;

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