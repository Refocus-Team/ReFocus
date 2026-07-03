# 🦉 ReFocus App — Asisten Fokus & Produktivitas Digital Anda

[![Flutter Version](https://img.shields.io/badge/Flutter-%E2%89%A53.0.0-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-%E2%89%A53.0.0-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Platforms](https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20Web-green)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**ReFocus** adalah aplikasi produktivitas berbasis Flutter yang dirancang khusus untuk membantu pengguna melacak waktu layar (*screen time*), mengurangi kecanduan media sosial, meningkatkan fokus harian, serta melatih kedisiplinan diri secara interaktif melalui metode gamifikasi.

---

## 🚀 Fitur Utama

### 1. 🔐 Autentikasi Pengguna & Sesi Persisten
* **Pendaftaran & Masuk Email**: Registrasi akun dan login secara mandiri menggunakan basis data lokal yang persisten.
* **Integrasi Kredensial Google & Apple**: Menghubungkan akun ReFocus Anda secara aman dengan pihak ketiga (Google & Apple) dengan tetap mewajibkan otorisasi nama akun dan kata sandi demi keamanan data.
* **Sesi Persisten**: Otomatis menyimpan sesi masuk pengguna via `shared_preferences` sehingga Anda tidak perlu login ulang saat aplikasi ditutup dan dibuka kembali.

### 2. 📊 Dasbor Analitik & Waktu Layar (Statistics Screen)
* **Today's Screen Time**: Melacak akumulasi pemakaian waktu layar harian secara presisi lengkap dengan persentase penurunan durasi hemat dibanding hari kemarin.
* **Mini Bar Chart**: Visualisasi grafik batang 8 kolom interaktif yang menggambarkan pembagian jam aktivitas pemakaian ponsel dalam sehari.
* **Current Streak**: Mengukur konsistensi fokus harian berturut-turut lengkap dengan indikator lingkaran centang sukses mingguan (`M`, `T`, `W`, `T`, `F`, `S`, `S`) serta emoji penyemangat.
* **Most Used Apps**: Daftar pelacakan detail penggunaan aplikasi terpopuler (Instagram, TikTok, YouTube, Facebook) lengkap dengan batas limit, persentase ketercapaian, dan bilah progres horizontal.

### 3. 🎮 Menu Tantangan Produktivitas (Challenge Menu)
* **Tantangan Harian (Daily Challenges)**: Ikuti kuis interaktif seperti *Memory Match*, *Math Sprint*, dan *Pattern Recall* untuk mengumpulkan poin.
* **Deep Focus Pomodoro**: Fitur fokus terpandu 25 menit yang terkunci guna mengamankan konsentrasi Anda dari gangguan luar.
* **Sistem Kunci Tantangan (Locking System)**: Fitur tantangan yang belum terbuka akan tampil transparan dan memiliki ikon gembok sebagai indikator target yang harus dicapai.

### 4. 🏆 Sistem Poin & Penghargaan (Profile & Achievements)
* **XP Progress Bar**: Slider level XP interaktif yang menunjukkan tingkat pertumbuhan produktivitas Anda (`Level 5 | Focus Master`).
* **Achievements Badge**: Kumpulkan 4 lencana penghargaan eksklusif:
  * 🦉 *First step*
  * ⏱️ *Time tracker*
  * 🛡️ *Limit setter*
  * 🔒 *Locked in*
* **Menu Profil Terintegrasi**: Akses cepat menuju halaman riwayat fokus (*Focus History*) dan toko poin (*My Points*).

### 5. 🔕 Mode Kerja Mendalam (Deep Work Mode)
* **Fokus Tanpa Batas**: Aktifkan sakelar *Deep Work Mode* di menu pengaturan untuk menyembunyikan atau memblokir seluruh notifikasi media sosial masuk demi perlindungan waktu produktif Anda secara maksimal.

---

## 📂 Struktur Proyek

Berikut adalah tata letak folder dan file utama pada aplikasi ReFocus:

```text
refocus/
├── assets/                    # Aset gambar, ikon menu, lencana penghargaan, dan maskot burung hantu
├── lib/
│   ├── models/
│   │   └── app_state.dart     # Pengelola status state global (Notifier) aplikasi (Poin, XP, Aplikasi Terpilih, Notifikasi)
│   ├── screens/
│   │   ├── intro_screen.dart           # Halaman pengantar fitur aplikasi (Walkthrough 1-3)
│   │   ├── login_screen.dart           # Halaman masuk akun (mendukung login Email & integrasi Google/Apple)
│   │   ├── signup_screen.dart          # Halaman daftar akun baru (mendukung daftar Email & integrasi Google/Apple)
│   │   ├── home_screen.dart            # Halaman utama aplikasi (statistik harian, pintasan mode fokus)
│   │   ├── statistics_screen.dart      # Halaman analitik detail grafik batang, streak harian, dan batas aplikasi
│   │   ├── challenge_menu_screen.dart  # Halaman daftar game produktivitas & meditasi Pomodoro
│   │   ├── profile_screen.dart         # Halaman data diri, progres XP, lencana pencapaian, dan pengaturan
│   │   ├── points_screen.dart          # Halaman informasi saldo poin dan riwayat transaksi poin
│   │   └── focus_history_screen.dart   # Halaman log aktivitas riwayat fokus pengguna
│   ├── services/
│   │   └── auth_service.dart  # Layanan penyimpanan kredensial & verifikasi akun lokal menggunakan SharedPreferences
│   ├── widgets/
│   │   └── bottom_navigation.dart # Widget menu navigasi bawah dengan desain lingkar aktif biru muda
│   └── main.dart              # Titik masuk utama aplikasi (Main entrypoint) & konfigurasi rute halaman
├── test/
│   └── widget_test.dart       # Pengujian unit smoke test untuk integritas kode aplikasi
└── README.md                  # Dokumentasi proyek
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
* **Untuk Perangkat Android/iOS/Emulator:**
  ```bash
  flutter run
  ```
* **Untuk Versi Web (Google Chrome):**
  ```bash
  flutter run -d chrome
  ```

### 4. Menjalankan Tes Unit
Untuk memastikan seluruh widget dan logika navigasi berfungsi dengan benar, jalankan perintah pengujian berikut:
```bash
flutter test
```

---

## 🛠️ Teknologi & Library

* **Framework:** [Flutter](https://flutter.dev) (Dart)
* **Penyimpanan Lokal:** [shared_preferences](https://pub.dev/packages/shared_preferences) untuk menyimpan database akun pengguna, sesi login, dan pengaturan secara persisten.
* **Ikon Grafik & Kanvas:** Menggunakan *Custom Painter* native Flutter untuk menggambar diagram melingkar (*circular progress*) pada dasbor.

---

## 📝 Lisensi

Proyek ini dilisensikan di bawah **MIT License** - lihat file [LICENSE](LICENSE) untuk detail lebih lanjut.

---

🦉 *Tetap Fokus, Kurangi Screen Time, dan Raih Produktivitas Terbaik Anda Bersama **ReFocus**!*

---

Dibuat dengan 💙 dan segelas matcha untuk membantu Anda tetap fokus.