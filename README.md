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

---

## Dokumentasi REST API

Aplikasi Course Data Manager kini terintegrasi dengan REST API untuk mengambil data course secara *real-time*. Berikut adalah detail endpoint yang digunakan:

### Informasi Endpoint
- **Base URL:** `https://course-api-pearl.vercel.app`
- **Endpoint (GET List Course):** `https://course-api-pearl.vercel.app/courses`
- **HTTP Method:** `GET`
- **Status Code (Sukses):** `200 OK`

### Struktur Response Body (JSON)
Response dari endpoint ini berupa *Array of Objects* (List) yang merepresentasikan data course. Berikut adalah minimal empat field utama yang ditemukan:

1. `id` (Integer): ID unik untuk setiap course.
2. `code` (String): Kode mata kuliah (contoh: "MOB01").
3. `title` (String): Judul/nama mata kuliah.
4. `credits` (Integer): Jumlah SKS.
5. `status` (String): Status course (contoh: "planned", "active", "done").

### Catatan Integrasi
- Pengambilan data menggunakan package `http`.
- Proses *fetching* API dilakukan di dalam `CourseService`, kemudian di-*parsing* menjadi object `Course`.
- Data mengalir dari Service -> Repository -> Provider -> UI.

---

## Cara Menjalankan Proyek
1. Pastikan Flutter SDK sudah terinstal di Device masing-masing
2. Jalankan perintah berikut di terminal:
   ```bash
   flutter pub get
   flutter run
   ```

---
