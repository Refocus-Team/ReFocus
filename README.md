# 🦉 ReFocus App — Asisten Fokus & Produktivitas Digital Anda

[![Flutter Version](https://img.shields.io/badge/Flutter-%E2%89%A53.0.0-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-%E2%89%A53.0.0-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Platforms](https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20Web-green)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-namamuajalah-yellow.svg)](LICENSE)

**ReFocus** adalah aplikasi produktivitas berbasis Flutter yang dirancang khusus untuk membantu pengguna melacak waktu layar (*screen time*), mengurangi kecanduan media sosial, meningkatkan fokus harian, serta melatih kedisiplinan diri secara interaktif melalui metode gamifikasi.

---

## 🚀 Fitur Utama

### 1. 🔐 Autentikasi Pengguna & Sesi Persisten
- **Pendaftaran & Masuk Email**: Registrasi akun dan login secara mandiri menggunakan basis data lokal yang persisten.
- **Integrasi Kredensial Google & Apple**: Menghubungkan akun ReFocus Anda secara aman dengan pihak ketiga (Google & Apple) dengan tetap mewajibkan otorisasi nama akun dan kata sandi demi keamanan data.
- **Sesi Persisten**: Otomatis menyimpan sesi masuk pengguna via `shared_preferences` sehingga Anda tidak perlu login ulang saat aplikasi ditutup dan dibuka kembali.

### 2. 📊 Dasbor Analitik & Waktu Layar (Statistics Screen)
- **Today's Screen Time**: Melacak akumulasi pemakaian waktu layar harian secara presisi lengkap dengan persentase penurunan durasi hemat dibanding hari kemarin.
- **Mini Bar Chart**: Visualisasi grafik batang 8 kolom interaktif yang menggambarkan pembagian jam aktivitas pemakaian ponsel dalam sehari.
- **Current Streak**: Mengukur konsistensi fokus harian berturut-turut lengkap dengan indikator lingkaran centang sukses mingguan (`M`, `T`, `W`, `T`, `F`, `S`, `S`) serta emoji penyemangat.
- **Most Used Apps**: Daftar pelacakan detail penggunaan aplikasi terpopuler (Instagram, TikTok, YouTube, Facebook) lengkap dengan batas limit, persentase ketercapaian, dan bilah progres horizontal.

### 3. 🎮 Menu Tantangan Produktivitas (Challenge Menu)
- **Tantangan Harian (Daily Challenges)**: Ikuti kuis interaktif seperti *Memory Match*, *Math Sprint*, dan *Pattern Recall* untuk mengumpulkan poin.
- **Deep Focus Pomodoro**: Fitur fokus terpandu 25 menit yang terkunci guna mengamankan konsentrasi Anda dari gangguan luar.
- **Sistem Kunci Tantangan (Locking System)**: Fitur tantangan yang belum terbuka akan tampil transparan dan memiliki ikon gembok sebagai indikator target yang harus dicapai.

### 4. 🏆 Sistem Poin & Penghargaan (Profile & Achievements)
- **XP Progress Bar**: Slider level XP interaktif yang menunjukkan tingkat pertumbuhan produktivitas Anda (`Level 5 | Focus Master`).
- **Achievements Badge**: Kumpulkan 4 lencana penghargaan eksklusif:
  - 🦉 *First step*
  - ⏱️ *Time tracker*
  - 🛡️ *Limit setter*
  - 🔒 *Locked in*
- **Menu Profil Terintegrasi**: Akses cepat menuju halaman riwayat fokus (*Focus History*) dan toko poin (*My Points*).

### 5. 🔕 Mode Kerja Mendalam (Deep Work Mode)
- **Fokus Tanpa Batas**: Aktifkan sakelar *Deep Work Mode* di menu pengaturan untuk menyembunyikan atau memblokir seluruh notifikasi media sosial masuk demi perlindungan waktu produktif Anda secara maksimal.

---

## 👥 Tim Pengembang

| Peran | Nama | Kontribusi |
|-------|------|------------|
| **UI/UX Designer** | **Erika Ayu Febrianti** | Merancang seluruh tampilan antarmuka pengguna (*wireframe*, *prototype*, *design system*), menentukan alur navigasi dan pengalaman pengguna (*user flow*), serta menyusun aset desain ikon, ilustrasi maskot, dan palet warna aplikasi. |
| **Frontend Engineer** | **Dio Lutvi Andre** | Membangun foundational code Flutter mencakup struktur awal *screens*, *widgets*, *routing*, dan integrasi dasar *state management*. |
| **Backend Engineer** | **Sofa Chasani Wibisono** | Melanjutkan dan menyelesaikan pengembangan setelah tahap awal Dio: integrasi *real-time service*, logika *gamifikasi* dan poin, sistem *streak*, koneksi *Platform Channel* untuk *screen time monitoring*, optimasi performa, *bug fixing*, pembersihan *deprecation warnings*, serta finalisasi seluruh fitur hingga **0 analyzer issues**. |

> **Catatan Alur Pengerjaan:** Proyek dikerjakan secara bertahap — **Erika** (UI/UX) menyelesaikan desain terlebih dahulu, dilanjutkan **Dio** (FE) membangun kerangka antarmuka murni secara mandiri, kemudian **Wibi** (BE) mengambil alih untuk mengintegrasikan logika backend, layanan *real-time*, dan menyempurnakan keseluruhan aplikasi hingga tahap rilis.

---

## 📂 Struktur Proyek

```text
refocus/
├── assets/                    # Aset gambar, ikon menu, lencana penghargaan, dan maskot burung hantu
├── lib/
│   ├── models/
│   │   ├── app_state.dart        # Pengelola status state global (Notifier) aplikasi
│   │   └── usage_repository.dart # Repository data pemakaian aplikasi & caching
│   ├── screens/
│   │   ├── intro_screen.dart           # Halaman pengantar fitur aplikasi (Walkthrough 1-3)
│   │   ├── login_screen.dart           # Halaman masuk akun
│   │   ├── signup_screen.dart          # Halaman daftar akun baru
│   │   ├── home_screen.dart            # Halaman utama aplikasi
│   │   ├── statistics_screen.dart      # Halaman analitik detail
│   │   ├── challenge_menu_screen.dart  # Halaman daftar game & tantangan
│   │   ├── challenge_play_screen.dart  # Halaman permainan Memory Match
│   │   ├── math_sprint_screen.dart     # Halaman permainan Math Sprint
│   │   ├── pattern_recall_screen.dart  # Halaman permainan Pattern Recall
│   │   ├── deep_focus_screen.dart      # Halaman mode fokus Pomodoro
│   │   ├── profile_screen.dart         # Halaman profil & pencapaian
│   │   ├── points_screen.dart          # Halaman saldo & riwayat poin
│   │   ├── focus_history_screen.dart   # Halaman log riwayat fokus
│   │   ├── select_apps_screen.dart     # Halaman pemilihan aplikasi
│   │   ├── set_limit_screen.dart       # Halaman pengaturan batas waktu
│   │   ├── notifications_screen.dart   # Halaman notifikasi
│   │   ├── permission_screen.dart      # Halaman izin akses
│   │   └── settings_screen.dart        # Halaman pengaturan umum
│   ├── services/
│   │   ├── auth_service.dart           # Layanan autentikasi lokal
│   │   ├── screen_time_service.dart    # Layanan monitor waktu layar (Platform Channel)
│   │   └── realtime_service.dart       # Layanan pembaruan data real-time
│   ├── widgets/
│   │   └── bottom_navigation.dart      # Widget navigasi bawah
│   └── main.dart                       # Titik masuk utama & routing
├── test/
│   └── widget_test.dart                # Pengujian unit smoke test
└── README.md                           # Dokumentasi proyek
```

---

## ⚙️ Langkah Instalasi

Pastikan komputer Anda telah terinstal **Flutter SDK** (versi ≥ 3.0.0) dan **Dart SDK**.

### 1. Kloning Repositori
```bash
git clone https://github.com/username/refocus.git
cd refocus
```

### 2. Unduh Dependensi
```bash
flutter pub get
```

### 3. Jalankan Aplikasi
- **Untuk Perangkat Android/iOS/Emulator:**
  ```bash
  flutter run
  ```
- **Untuk Versi Web (Google Chrome):**
  ```bash
  flutter run -d chrome
  ```

### 4. Menjalankan Tes Unit
```bash
flutter test
```

---

## 🛠️ Teknologi & Library

- **Framework:** [Flutter](https://flutter.dev) (Dart)
- **Penyimpanan Lokal:** [shared_preferences](https://pub.dev/packages/shared_preferences)
- **Platform Channel:** MethodChannel & EventChannel untuk komunikasi native (screen time monitoring)
- **State Management:** StatefulWidget + ChangeNotifier pattern via `AppState`
- **Grafik & Kanvas:** *Custom Painter* native Flutter untuk diagram melingkar dan bilah progres

---

## 📝 Lisensi

Proyek ini dilisensikan di bawah *namamu aja lah License*.

---

🦉 *Tetap Fokus, Kurangi Screen Time, dan Raih Produktivitas Terbaik Anda Bersama **ReFocus**!*

---

Dibuat dengan 💙 oleh tim **Erika - Dio - Wibi** untuk membantu Anda tetap fokus.
