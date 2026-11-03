# Flutter UI Fundamentals

Proyek ini dibuat sebagai ruang latihan untuk memahami konsep dasar pembuatan User Interface (UI) pada aplikasi mobile menggunakan framework Flutter.

## Identitas Pengembang
* **Nama**  : I Putu Budha Aditya
* **NIM**   : 2415051006
* **Kelas** : PTI 5A

## Tentang Aplikasi
* **Teknologi** : Flutter & Dart
* **Tujuan**    : Latihan pembuatan layout, widget, dan navigasi dasar pada mobile apps.
* **Lingkungan**: Linux Mint 22.2 Cinnamon

# Course Explorer v2 - Architecture

Aplikasi ini menerapkan prinsip *Separation of Concerns* dengan struktur folder sebagai berikut:

- **`models/`**: Berisi definisi struktur data (contoh: `Course`). Bertanggung jawab untuk *parsing* JSON ke dalam objek Dart (`Course.fromJson`).
- **`services/`**: Berisi logika pengambilan data mentah (contoh: `CourseService` yang menggunakan `rootBundle`). Layer ini tidak tahu tentang state atau UI.
- **`repositories/`**: Menjadi jembatan antara Service dan Provider. Menyembunyikan detail sumber data dari Provider.
- **`providers/`**: Mengelola state aplikasi (contoh: `CourseProvider`) seperti *loading*, *error*, data *course*, dan *favorite*. Menggunakan `ChangeNotifier` untuk memberi tahu UI.
- **`screens/`**: Berisi halaman utama aplikasi (Dashboard, MainShell, dan Tab-tab). Bertanggung jawab merangkai widget.
- **`widgets/`**: Berisi komponen UI kecil yang dapat digunakan ulang (contoh: `CourseCard`, `CourseGrid`).

## Alur Dependency
`UI (Screens/Widgets)` -> `Provider` -> `Repository` -> `Service (JSON)`
UI tidak memanggil Service secara langsung.

## Cara Menjalankan Proyek
1. Pastikan Flutter SDK sudah terinstal di Device masing-masing
2. Jalankan perintah berikut di terminal:
   ```bash
   flutter pub get
   flutter run
   ```

---
